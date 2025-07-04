return {
    {
        "folke/which-key.nvim",
        optional = true,
        opts = { defaults = { ["<leader>t"] = { name = "+test" } } },
    },
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-neotest/nvim-nio",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-neotest/neotest-python",
            "MisanthropicBit/neotest-jest", -- "nvim-neotest/neotest-jest", https://github.com/nvim-neotest/neotest-jest/pull/111
        },
        config = function(_, _)
            require("neotest").setup({
                -- Can be a list of adapters like what neotest expects,
                -- or a list of adapter names,
                -- or a table of adapter names, mapped to adapter configs.
                -- The adapter will then be automatically loaded with the config.
                adapters = {
                    require("rustaceanvim.neotest")({}),
                    require("neotest-python")({
                        dap = { justMyCode = false },
                        runner = "unittest",
                        python = function()
                            local path = require("raven.utils").venv_python_path()
                            if not path then
                                vim.notify("No valid Python venv found", vim.log.levels.WARN)
                            end
                            return path
                        end,

                    }
                    ),
                    require("neotest-jest")({
                        jestCommand = "npm test --",
                        jestConfigFile = "jest.config.mjs",
                        dap = {
                            justMyCode = false,
                            -- dap_config_name = "Debug Jest Tests",
                        },
                        env = { CI = true },
                        cwd = function()
                            return vim.fn.getcwd()
                        end,
                    }),
                },
                status = { virtual_text = true },
                output = { open_on_run = true },
            })
        end,
        keys = {
            {
                "<leader>tt",
                function()
                    require("neotest").run.run(vim.fn.expand("%"))
                end,
                desc = "Run File",
            },
            {
                "<leader>tT",
                function()
                    require("neotest").run.run(vim.loop.cwd())
                end,
                desc = "Run All Test Files",
            },
            {
                "<leader>tr",
                function()
                    require("neotest").run.run()
                end,
                desc = "Run Nearest",
            },
            {
                "<leader>td",
                function()
                    require("neotest").run.run({ strategy = "dap" })
                end,
                desc = "Debug Nearest",
            },
            {
                "<leader>ts",
                function()
                    require("neotest").summary.toggle()
                end,
                desc = "Toggle Summary",
            },
            {
                "<leader>to",
                function()
                    require("neotest").output.open({
                        enter = true,
                        auto_close = true,
                    })
                end,
                desc = "Show Output",
            },
            {
                "<leader>tO",
                function()
                    require("neotest").output_panel.toggle()
                end,
                desc = "Toggle Output Panel",
            },
            {
                "<leader>tS",
                function()
                    require("neotest").run.stop()
                end,
                desc = "Stop",
            },
        },
    },
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            {
                "williamboman/mason.nvim",
                opts = { ensure_installed = { "java-debug-adapter", "java-test", "js-debug-adapter" } },
            },
            {
                "mfussenegger/nvim-dap-python",
                keys = {
                    {
                        "<leader>dPt",
                        function()
                            require("dap-python").test_method()
                        end,
                        desc = "Debug Method",
                    },
                    {
                        "<leader>dPc",
                        function()
                            require("dap-python").test_class()
                        end,
                        desc = "Debug Class",
                    },
                },
                config = function()
                    require("dap-python").setup(require("raven.utils").venv_python_path())
                end,
            },
            { "theHamsta/nvim-dap-virtual-text", opts = {} },
            {
                "folke/which-key.nvim",
                optional = true,
                opts = {
                    defaults = {
                        ["<leader>d"] = { name = "+debug" },
                        ["<leader>da"] = { name = "+adapters" },
                    },
                },
            },
            {
                "rcarriga/nvim-dap-ui",
                keys = {
                    {
                        "<leader>du",
                        function()
                            require("dapui").toggle({})
                        end,
                        desc = "Dap UI",
                    },
                    {
                        "<leader>de",
                        function()
                            require("dapui").eval()
                        end,
                        desc = "Eval",
                        mode = { "n", "v" },
                    },
                },
                opts = {},
                config = function(_, opts)
                    local dap = require("dap")
                    local dapui = require("dapui")
                    dapui.setup(opts)
                    dap.listeners.after.event_initialized["dapui_config"] = function()
                        dapui.open({})
                    end
                    dap.listeners.before.event_terminated["dapui_config"] = function()
                        dapui.close({})
                    end
                    dap.listeners.before.event_exited["dapui_config"] = function()
                        dapui.close({})
                    end
                end,
            },
            {
                "jay-babu/mason-nvim-dap.nvim",
                dependencies = { { "williamboman/mason.nvim" } },
                cmd = { "DapInstall", "DapUninstall" },
                opts = {
                    automatic_installation = true,
                    -- see mason-nvim-dap README for more information
                    handlers = {},
                    ensure_installed = {
                        "python",
                        "codelldb",
                        "js-debug-adapter",
                    },
                },
                config = function(_, opts)
                    require("mason-nvim-dap").setup(opts)
                end,
            },
        },
        config = function()
            local dap = require('dap')

            dap.defaults.fallback.pythonPath = require("raven.utils").venv_python_path()

            local mason_path = vim.fn.stdpath("data") .. "/mason"

            dap.adapters.lldb = {
                type = "executable",
                command = mason_path .. "/packages/codelldb/codelldb",
                name = "codelldb",
            }

            dap.configurations.python = {
                {
                    type = 'python',
                    request = 'launch',
                    name = 'Launch file',
                    program = "${file}",
                    pythonPath = require("raven.utils").venv_python_path()
                },
                {
                    type = 'python',
                    request = 'launch',
                    name = 'Launch main',
                    program = "main.py",
                    pythonPath = require("raven.utils").venv_python_path()
                },
            }
            dap.configurations.rust = {
                {
                    name = "zilia",
                    type = "lldb",
                    request = "launch",
                    program = function()
                        return vim.fn.getcwd() .. "/target/dx/zilia-dashboard/debug/linux/app/zilia-dashboard"
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                }
            }
            dap.configurations.java = {
                {
                    name = "Debug Launch",
                    type = 'java',
                    request = 'launch',
                    vmArgs = "" .. "-Xmx2g",
                    mainClass = "${file}",
                    projectName = "${workspaceFolder}",
                },
                {
                    name = "Debug Attach (8000)",
                    type = "java",
                    request = "attach",
                    hostName = "127.0.0.1",
                    port = 5005,
                },
                {
                    name      = "QM Java Runner",
                    type      = "java",
                    request   = "launch",
                    mainClass = "ca.ulaval.glo4002.application.ApplicationServer",
                    vmArgs    = "" .. "-Xmx2g"
                },
                {
                    name      = "ARCHI Java Runner",
                    type      = "java",
                    request   = "launch",
                    mainClass = "ca.ulaval.glo4003.Main",
                    vmArgs    = "" .. "-Xmx2g"
                }
            }

            if not dap.adapters["pwa-node"] then
                require("dap").adapters["pwa-node"] = {
                    type = "server",
                    host = "localhost",
                    port = "${port}",
                    executable = {
                        command = "node",
                        args = { mason_path .. "/packages/js-debug-adapter/js-debug/src/dapDebugServer.js", "${port}" },
                    },
                }
            end
            if not dap.adapters["node"] then
                dap.adapters["node"] = function(cb, config)
                    if config.type == "node" then
                        config.type = "pwa-node"
                    end
                    local nativeAdapter = dap.adapters["pwa-node"]
                    if type(nativeAdapter) == "function" then
                        nativeAdapter(cb, config)
                    else
                        cb(nativeAdapter)
                    end
                end
            end

            local js_filetypes = { "typescript", "javascript" }

            local vscode = require("dap.ext.vscode")
            vscode.type_to_filetypes["node"] = js_filetypes
            vscode.type_to_filetypes["pwa-node"] = js_filetypes

            dap.configurations.typescript = {
                {
                    name = "Debug (npm run start:dev)",
                    type = "pwa-node",
                    request = "launch",
                    cwd = "${workspaceFolder}",
                    runtimeExecutable = "npx",
                    runtimeArgs = { "tsx", "watch", "--env-file=.env", "src/main.ts", },
                    console = "integratedTerminal",
                },
                {
                    type = "pwa-node",
                    request = "launch",
                    name = "Launch file",
                    program = "${file}",
                    cwd = "${workspaceFolder}",
                    console = "integratedTerminal",
                },
                {
                    type = "pwa-node",
                    request = "attach",
                    name = "Attach",
                    processId = require("dap.utils").pick_process,
                    cwd = "${workspaceFolder}",
                    console = "integratedTerminal",
                },
                {
                    name = "Debug Tests (current file)",
                    type = "pwa-node",
                    request = "launch",
                    cwd = "${workspaceFolder}",
                    runtimeExecutable = "npx",
                    runtimeArgs = { "jest", "${file}", "--runInBand", "--no-cache", "--watchAll=false", },
                    console = "integratedTerminal",
                },
            }

            dap.configurations.javascript = dap.configurations.typescript
        end,
        keys = {
            {
                "<leader>dB",
                function()
                    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
                end,
                desc = "Breakpoint Condition",
            },
            {
                "<leader>db",
                function()
                    require("dap").toggle_breakpoint()
                end,
                desc = "Toggle Breakpoint",
            },
            {
                "<leader>dc",
                function()
                    require("dap").continue()
                end,
                desc = "Continue",
            },
            {
                "<leader>dC",
                function()
                    require("dap").run_to_cursor()
                end,
                desc = "Run to Cursor",
            },
            {
                "<leader>dg",
                function()
                    require("dap").goto_()
                end,
                desc = "Go to line (no execute)",
            },
            {
                "<leader>di",
                function()
                    require("dap").step_into()
                end,
                desc = "Step Into",
            },
            {
                "<leader>dj",
                function()
                    require("dap").down()
                end,
                desc = "Down",
            },
            {
                "<leader>dk",
                function()
                    require("dap").up()
                end,
                desc = "Up",
            },
            {
                "<leader>dl",
                function()
                    require("dap").run_last()
                end,
                desc = "Run Last",
            },
            {
                "<leader>dO",
                function()
                    require("dap").step_out()
                end,
                desc = "Step Out",
            },
            {
                "<leader>do",
                function()
                    require("dap").step_over()
                end,
                desc = "Step Over",
            },
            {
                "<leader>dp",
                function()
                    require("dap").pause()
                end,
                desc = "Pause",
            },
            {
                "<leader>dr",
                function()
                    require("dap").repl.toggle()
                end,
                desc = "Toggle REPL",
            },
            {
                "<leader>ds",
                function()
                    require("dap").session()
                end,
                desc = "Session",
            },
            {
                "<leader>dt",
                function()
                    require("dap").terminate()
                end,
                desc = "Terminate",
            },
            {
                "<leader>dw",
                function()
                    require("dap.ui.widgets").hover()
                end,
                desc = "Widgets",
            },
        },
    },
}
