local M = {}

function M:setup()
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
  local workspace_dir = vim.fn.stdpath("data") ..
  package.config:sub(1, 1) .. "jdtls-workspace" .. package.config:sub(1, 1) .. project_name
  local os_name = vim.loop.os_uname().sysname
  local config = {
    -- The command that starts the language server
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    cmd = {

      -- 💀
      "/Users/yan/Library/Java/JavaVirtualMachines/ms-21.0.9/Contents/Home/bin/java",       -- or '/path/to/java17_or_newer/bin/java'
      -- depends on if `java` is in your $PATH env variable and if it points to the right version.

      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dlog.protocol=true",
      "-Dlog.level=ALL",
      "-javaagent:" .. vim.fn.stdpath("data")  .. "/mason/share/jdtls/lombok.jar",
      "-Xmx4g",
      "--add-modules=ALL-SYSTEM",
      "--add-opens",
      "java.base/java.util=ALL-UNNAMED",
      "--add-opens",
      "java.base/java.lang=ALL-UNNAMED",

      -- 💀
      "-jar",
      vim.fn.stdpath("data") ..
      package.config:sub(1, 1) ..
      "mason" ..
      package.config:sub(1, 1) ..
      "packages" ..
      package.config:sub(1, 1) ..
      "jdtls" ..
      package.config:sub(1, 1) ..
      "plugins" .. package.config:sub(1, 1) .. "org.eclipse.equinox.launcher_1.7.100.v20251014-1222.jar",
      -- Must point to the                                                     Change this to
      -- eclipse.jdt.ls installation                                           the actual version

      -- 💀
      "-configuration",
      vim.fn.stdpath("data") ..
      package.config:sub(1, 1) ..
      "mason" ..
      package.config:sub(1, 1) ..
      "packages" ..
      package.config:sub(1, 1) ..
      "jdtls" ..
      package.config:sub(1, 1) ..
      "config_" .. (os_name == "Windows_NT" and "win" or os_name == "Linux" and "linux" or "mac"),
      -- eclipse.jdt.ls installation            Depending on your system.

      -- 💀
      -- See `data directory configuration` section in the README
      "-data",
      workspace_dir,
    },

    -- 💀
    -- This is the default if not provided, you can remove it. Or adjust as needed.
    -- One dedicated LSP server & client will be started per unique root_dir
    root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "settings.gradle", "pom.xml" }),

    -- Here you can configure eclipse.jdt.ls specific settings
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- for a list of options
    settings = {
      java = {
        configuration = {
          runtimes = {
            {
              name = "JavaSE-25", path = "/Users/yan/Library/Java/JavaVirtualMachines/openjdk-25.0.1/Contents/Home"
            },
            {
              name = "JavaSE-24", path = "/Users/yan/Library/Java/JavaVirtualMachines/azul-24.0.2/Contents/Home"
            },
            {
              name = "JavaSE-17", path = "/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home"
            },
          }
        }
      },
    },
  }
  -- This starts a new client & server,
  -- or attaches to an existing client & server depending on the `root_dir`.
  require("jdtls").start_or_attach(config)
end

return M
