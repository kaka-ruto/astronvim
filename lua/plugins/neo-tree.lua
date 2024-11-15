-- Customize neo-tree

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        mappings = {
          ["s"] = {
            command = function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              require("spectre").open {
                cwd = path,
                path = path,
                is_insert_mode = true,
                is_close = false,
              }
              vim.cmd "neotree close"
            end,
            desc = "Search & replace in file/directory",
          },
        },
      },
    },
  },
}
