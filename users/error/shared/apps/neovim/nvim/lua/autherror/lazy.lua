-- boostrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- give lazy something to do
require("lazy").setup("autherror.plugins", {
    -- dev = {
    --     path = "~/.local/share/nvim/from-nix",
    --     fallback = false,
    -- },
    change_detection = {
        enabled = false,
    },
    performance = {
        reset_packpath = false,
        rtp = {
            reset = false,
        },
    },
})
