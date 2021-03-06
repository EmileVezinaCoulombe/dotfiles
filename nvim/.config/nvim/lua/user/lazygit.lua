local status_ok, lazygit = pcall(require, "lazygit")
if not status_ok then
    return
end

lazygit.lazygit_floating_window_winblend = 0 -- transparency of floating window
lazygit.lazygit_floating_window_scaling_factor = 0.9 -- scaling factor for floating window
lazygit.lazygit_floating_window_use_plenary = 0 -- use plenary.nvim to manage floating window if available
lazygit.lazygit_use_neovim_remote = 1 -- fallback to 0 if neovim-remote is not installed
