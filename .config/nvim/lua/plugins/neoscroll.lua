return {
  "karb94/neoscroll.nvim",
  lazy = false,
  config = function()
    local ns = require("neoscroll")
    -- neoscroll has no public cancel/inspect API (init.lua only exports
    -- scroll/new_scroll/ctrl_*/z*/G/gg/setup), so canceling an in-flight
    -- animation means reaching into its private submodules. Pinned to
    -- c8d29979 -- re-diff scroll.lua/config.lua field names if that commit
    -- ever moves. Only zt/zz/zb/<C-y>/<C-e> still go through neoscroll's own
    -- setup() below -- <C-d>/<C-u>/<C-f>/<C-b> are a hand-rolled animator
    -- (see the big comment above `anim`), so this cancel function is only
    -- needed to stop THOSE four keys' in-flight neoscroll animation before
    -- our own animator starts moving the same window.
    local scroll_state = require("neoscroll.scroll")
    local neoscroll_opts = require("neoscroll.config").opts

    local function force_stop_scroll()
      if not scroll_state.scrolling then
        return
      end
      scroll_state.timer:stop()
      if next(neoscroll_opts.ignored_events) ~= nil then
        vim.opt.eventignore:remove(neoscroll_opts.ignored_events)
      end
      vim.wo.scrolloff = vim.go.scrolloff
      scroll_state.relative_line = 0
      scroll_state.target_line = 0
      scroll_state.scrolling = false
      scroll_state.continuous_scroll = false
    end

    ns.setup({
      stop_eof = false,
      -- <C-d>/<C-u>/<C-f>/<C-b> are bound below with a hand-rolled animator
      -- instead of through here -- see the big comment above `anim`.
      mappings = { "zt", "zz", "zb", "<C-y>", "<C-e>" },
    })

    -- ==========================================================================
    -- Hand-rolled dual-axis animator for <C-d>/<C-u>/<C-f>/<C-b>.
    --
    -- WHY (rounds 7-10, 2026-07-07/08 -- see engram/session history for the
    -- full trail, this is the 4th attempt at the same underlying complaint):
    -- neoscroll's own scroll() can only move window+cursor by the SAME delta
    -- in one call (confirmed from source: scroll:scroll_one_line issues one
    -- shared vim.cmd.normal per frame). Centering the cursor therefore
    -- REQUIRES a second, separately-scheduled scroll() call after the first
    -- one finishes -- and whenever that base lockstep landing spot differs
    -- from the ideal centered topline (true for any press before the window
    -- reaches steady state), the window visibly moves there, stops, then
    -- visibly moves AGAIN to the correction target: a real two-phase
    -- "wobble". Proven NOT fixable by tapering the correction's strength
    -- (tried twice, rounds 8-9): taper only suppresses the correction right
    -- at BOF/EOF; for any scroll/height ratio where convergence takes MORE
    -- presses than the taper takes to saturate to full strength (confirmed
    -- exactly for THIS file: winheight=36/scroll=8/half=18 converges by
    -- press 4, but taper saturates by press 3), there's a real gap with a
    -- full-strength correction firing against a still-unconverged window --
    -- an unavoidable visible wobble, for ANY exponent.
    --
    -- Fix: compute the ONE true final target for BOTH axes (topline, cursor)
    -- up front, once per keypress, and animate a single continuous glide
    -- straight to it -- never through an intermediate lockstep landing spot.
    -- Modeled on cinnamon.nvim's own scroller (declancm/cinnamon.nvim,
    -- scroll.lua @ 450cb324, confirmed via source read): one shared timer,
    -- one independent linear start->target ramp per axis, both driven by the
    -- SAME time fraction every frame so neither axis "waits" for the other,
    -- interpolated in wall-clock time so libuv's imprecise timer callback
    -- firing never distorts the glide.
    -- ==========================================================================

    local anim = {
      timer = vim.uv.new_timer(), -- one persistent timer, like neoscroll's own scroll.timer singleton
      gen = 0, -- staleness token (mini.nvim-style): bump on every new press, stale ticks quietly no-op
      running = false,
      winid = nil,
      start_time = nil,
      duration = nil,
      start_topline = nil,
      start_cursor = nil,
      target_view = nil, -- full winsaveview()-shaped dict at the resolved target (topline overridden below)
      logical_cursor = nil, -- LOGICAL target line, survives interruption -- see resolve_target_view
      cur_topline = nil,
      cur_cursor = nil,
      guicursor = nil,
    }

    local function anim_hide_cursor()
      if vim.o.termguicolors and vim.o.guicursor ~= "" then
        anim.guicursor = vim.o.guicursor
        vim.o.guicursor = "a:NeoscrollHiddenCursor"
      end
    end

    local function anim_unhide_cursor()
      if vim.o.guicursor == "a:NeoscrollHiddenCursor" then
        vim.o.guicursor = anim.guicursor
      end
    end

    -- Render one frame: interpolated topline/cursor during the glide, or the
    -- exact final target when snapping (see anim_teardown below).
    local function render_frame(winid, topline, cursor_line)
      local view = vim.tbl_extend("force", anim.target_view, { topline = topline, lnum = cursor_line })
      vim.api.nvim_win_call(winid, function()
        vim.fn.winrestview(view)
      end)
    end

    local function anim_teardown()
      local was_running = anim.running
      anim.timer:stop()
      anim.running = false
      -- Snap to the exact final target before releasing, instead of freezing
      -- mid-glide. Real bug caught by Oracle verification (round 10 review,
      -- not by the QA that shipped it): switching window focus ~30ms into a
      -- <C-d> glide fires WinLeave, which calls this function -- but it only
      -- stopped the timer and restored scrolloff/eventignore/cursor, never
      -- finished the visual move, leaving the ABANDONED window's cursor
      -- frozen at whatever intermediate line the last frame happened to
      -- render. Self-healing (the next press in that window recomputes
      -- correctly from wherever it sits) but visibly wrong until then --
      -- snap to the logical target so teardown always leaves a CORRECT, not
      -- merely a safe, final state.
      if was_running and anim.winid and vim.api.nvim_win_is_valid(anim.winid) then
        render_frame(anim.winid, anim.target_view.topline, anim.logical_cursor)
      end
      anim_unhide_cursor()
      if next(neoscroll_opts.ignored_events) ~= nil then
        vim.opt.eventignore:remove(neoscroll_opts.ignored_events)
      end
      if anim.winid and vim.api.nvim_win_is_valid(anim.winid) then
        vim.wo[anim.winid].scrolloff = vim.go.scrolloff
      end
    end

    -- Resolve the true target view by peeking with real, fold- and wrapped-
    -- line-aware motions (gj/gk) -- exactly like cinnamon.nvim does for all 4
    -- of its axes -- reusing Vim's own display-line engine instead of hand-
    -- rolling fold/wrap arithmetic. Peeks from `from_line`, the LOGICAL chain
    -- point -- NEVER the live physical cursor position. That distinction is
    -- load-bearing, not stylistic: mid-animation, the physical cursor lags
    -- behind the logical target (the glide hasn't finished yet), so peeking
    -- from wherever it physically sits would silently compute a target
    -- relative to the WRONG start point and break the already-validated
    -- "cursor moves by exactly N*scroll lines, every press, even under rapid
    -- repeated presses" invariant (verified: 35 rapid presses must land on
    -- exactly line 1+8*35, both directions -- this is the exact regression
    -- class that bit round 8's first cut, caught via headless per-press
    -- diagnostic). Chaining off the logical target instead mirrors
    -- neoscroll's own precedent for the analogous problem (init.lua:
    -- `scroll.target_line = scroll.target_line + lines` when already
    -- scrolling adjusts the LOGICAL target, never re-reads live position).
    --
    -- ponytail: only the CURSOR's target is peek-resolved (fold/wrap-aware).
    -- topline's target below is still buffer-line arithmetic (closed-form),
    -- an approximation of "exactly half a window" when folds/wraps sit
    -- between topline and cursor -- same approximation neoscroll's own
    -- catchup logic in scroll_one_line already accepted. Upgrade path: peek
    -- for topline too if that ever visibly misplaces centering.
    local function resolve_target_view(winid, from_line, lines)
      local saved = vim.api.nvim_win_call(winid, vim.fn.winsaveview)
      vim.api.nvim_win_call(winid, function()
        vim.fn.winrestview({ lnum = from_line, col = saved.col, curswant = saved.curswant })
        local cmd = string.rep(lines > 0 and "gj" or "gk", math.abs(lines))
        pcall(vim.cmd.normal, { bang = true, args = { cmd } })
      end)
      local target_view = vim.api.nvim_win_call(winid, vim.fn.winsaveview)
      vim.api.nvim_win_call(winid, function()
        vim.fn.winrestview(saved)
      end)
      return target_view
    end

    local function closed_form_topline(winid, target_cursor)
      local height = vim.api.nvim_win_call(winid, function()
        return vim.fn.winheight(0)
      end)
      local half = math.ceil(height / 2)
      local last_line = vim.api.nvim_win_call(winid, function()
        return vim.fn.line("$")
      end)
      local max_topline = math.max(1, last_line - height + 1)
      return math.min(math.max(target_cursor - half + 1, 1), max_topline)
    end

    local function start_anim(lines, duration)
      local winid = vim.api.nvim_get_current_win()
      force_stop_scroll() -- cancel any in-flight zt/zz/zb/<C-y>/<C-e> neoscroll animation first

      local chaining = anim.running and anim.winid == winid
      local from_line = chaining and anim.logical_cursor or vim.fn.line(".")

      if chaining then
        -- Continue rendering from wherever the last frame visually was, not
        -- from the (irrelevant now) old target -- avoids a visible snap.
        anim.start_topline, anim.start_cursor = anim.cur_topline, anim.cur_cursor
      else
        anim.start_topline = vim.fn.line("w0")
        anim.start_cursor = from_line
      end

      local last_line = vim.api.nvim_win_call(winid, function()
        return vim.fn.line("$")
      end)
      from_line = math.min(math.max(from_line, 1), last_line)

      local target_view = resolve_target_view(winid, from_line, lines)
      target_view.lnum = math.min(math.max(target_view.lnum, 1), last_line)
      target_view.topline = closed_form_topline(winid, target_view.lnum)

      anim.gen = anim.gen + 1
      local my_gen = anim.gen
      anim.winid = winid
      anim.target_view = target_view
      anim.logical_cursor = target_view.lnum
      anim.duration = duration
      anim.start_time = vim.uv.now()
      anim.cur_topline, anim.cur_cursor = anim.start_topline, anim.start_cursor

      if not anim.running then
        anim.running = true
        anim_hide_cursor()
        if next(neoscroll_opts.ignored_events) ~= nil then
          vim.opt.eventignore:append(neoscroll_opts.ignored_events)
        end
        vim.wo[winid].scrolloff = 0
      end

      anim.timer:stop()
      anim.timer:start(
        0,
        16,
        vim.schedule_wrap(function()
          if my_gen ~= anim.gen then
            return -- stale tick from an interrupted leg (mini.nvim-style staleness check)
          end
          if not vim.api.nvim_win_is_valid(anim.winid) then
            anim_teardown()
            return
          end
          local t = math.min((vim.uv.now() - anim.start_time) / anim.duration, 1)
          local topline = math.floor(anim.start_topline + (anim.target_view.topline - anim.start_topline) * t + 0.5)
          local cursor_line = math.floor(anim.start_cursor + (anim.target_view.lnum - anim.start_cursor) * t + 0.5)
          anim.cur_topline, anim.cur_cursor = topline, cursor_line
          render_frame(anim.winid, topline, cursor_line)
          if t >= 1 then
            anim_teardown()
          end
        end)
      )
    end

    -- neoscroll's own WinLeave teardown (init.lua) only watches ITS
    -- scroll.scrolling flag -- won't stop our timer, so we need our own.
    -- Named + cleared augroup (not a bare autocmd): Oracle review (2026-07-08,
    -- 3rd pass) found re-running config() in-session (e.g. :Lazy reload while
    -- iterating on this file) added a second copy of this autocmd every time,
    -- since a plain nvim_create_autocmd call has no identity to dedupe on --
    -- clear=true makes reload idempotent instead of leaking one more listener
    -- per reload.
    vim.api.nvim_create_autocmd({ "WinLeave", "WinClosed" }, {
      group = vim.api.nvim_create_augroup("neoscroll_animator", { clear = true }),
      callback = function()
        if anim.running then
          anim.gen = anim.gen + 1
          anim_teardown()
        end
      end,
    })

    local function scroll_cmd(get_lines, duration)
      return function()
        start_anim(get_lines(), duration)
      end
    end

    vim.keymap.set("n", "<C-d>", scroll_cmd(function()
      return vim.wo.scroll
    end, 150))
    vim.keymap.set("n", "<C-u>", scroll_cmd(function()
      return -vim.wo.scroll
    end, 150))
    vim.keymap.set("n", "<C-f>", scroll_cmd(function()
      return vim.fn.winheight(0)
    end, 250))
    vim.keymap.set("n", "<C-b>", scroll_cmd(function()
      return -vim.fn.winheight(0)
    end, 250))
  end,
}
