-- Customize nvim-spectre

---@type LazySpec
return {
  "nvim-pack/nvim-spectre",
  config = function()
    require("spectre").setup {
      is_block_ui_break = true,
      replace_engine = {
        ["sed"] = {
          cmd = "sed",
          args = {
            "-i",
            "",
            "-E",
          },
        },
      },
    }
  end,
}
