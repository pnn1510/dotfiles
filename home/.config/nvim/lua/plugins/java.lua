return {
  {
    "mfussenegger/nvim-jdtls",
    opts = {
      cmd = (function()
        -- Use vim.fn.expand to expand ~ in JAVA_HOME path
        vim.env.JAVA_HOME = vim.fn.expand("~/.asdf/installs/java/adoptopenjdk-21.0.6+7.0.LTS/")

        local jdtls_bin = vim.fn.stdpath("data") .. "/mason/bin/jdtls"
        local jdtls_pkg = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
        local workspace = vim.fn.stdpath("cache") .. "/nvim/jdtls/workspace"

        -- Determine platform config folder
        local uv = vim.uv or vim.loop
        local os_name = uv.os_uname().sysname
        local config_folder = "config_linux"

        if os_name == "Darwin" then
          config_folder = "config_mac"
        elseif os_name == "Windows_NT" then
          config_folder = "config_win"
        end

        local cmd = {
          jdtls_bin,
          "--jvm-arg=-javaagent:" .. jdtls_pkg .. "/lombok.jar",
          "-configuration",
          jdtls_pkg .. "/" .. config_folder,
          "-data",
          workspace,
        }

        -- Notify the full command for debugging
        vim.schedule(function()
          vim.notify(
            "Starting jdtls with command:\n" .. table.concat(cmd, " "),
            vim.log.levels.INFO,
            { title = "jdtls cmd" }
          )
        end)

        return cmd
      end)(),
    },
  },
}
