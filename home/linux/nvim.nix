{ pkgs, ... }:

{
  
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      softtabstop = 2;
      expandtab = true;
      smartindent = true;
      wrap = false;
      ignorecase = true;
      smartcase = true;
      mouse = "a";
      termguicolors = true;

      # UI settings
      cursorline = true;
      signcolumn = "yes";
    };

    globals.mapleader = " ";
    keymaps = [
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Neotree toggle<cr>";
        options.desc = "Toggle Explorer";
      }
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<cr>";
        options.desc = "Find Files";
      }
      {
        mode = "n";
        key "<leader>fg";
        action = "<cmd>Telescope live_grep<cr>";
        options.desc = "Grep Files";
      }
    ];

    colorschemes.gruvbox = {
      enable = true;
      settings = {
        background = "dark";
        contrast - "medium";
        transparent_mode = false;
      };
    };

    plugins = {
      # UI
      lualine.enable = true;
      bufferline.enable = true;
      neo-tree.enable = true;
      which-key.enable = true;

      # Finder
      telescop = {
        enable = true;
        extensions = {
          fzf-native.enable = true;
        };
      };

      # Treesitter (Syntax Highlighting)
      treesitter = {
        enable  = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };

      # LSP & Completion
      lsp = {
        enable = true;
        servers = {
          nixd.enable = true;
          lua_ls.enable = true;
          rust_analyzer.enable = true;
          pyright.enable = true;
        };
      };

      cmp = {
        enable = true;
        settings = {
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-e>" = "cmp.mapping.close()";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          };
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
        };
      };

    }

  };

}
