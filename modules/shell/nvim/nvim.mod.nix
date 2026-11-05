{ lib, ... }:
let
  mkNvim =
    pkgs:
    pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
      withPython3 = false;
      withRuby = false;
      withNodeJs = false;

      wrapRc = false;

      plugins = with pkgs.vimPlugins; [
        # syntax
        (nvim-treesitter.withAllGrammars)
        nvim-treesitter-textobjects

        # completion
        blink-cmp
        friendly-snippets

        # picker
        snacks-nvim

        # keymaps
        which-key-nvim

        # statusline + buffers
        lualine-nvim
        bufferline-nvim

        # editing
        mini-nvim
        flash-nvim
        trouble-nvim
        vim-sleuth
        ts-comments-nvim

        # ui
        gruvbox-nvim
        noice-nvim
        nui-nvim
        nvim-web-devicons

        # lsp
        nvim-lspconfig
      ];

      wrapperArgs = [
        "--prefix"
        "PATH"
        ":"
        (lib.makeBinPath (with pkgs; [
          ripgrep
          fd
          fzf
          stylua
          nil
          lua-language-server
        ]))
      ];
    };
in
{
  flake.modules.nixos.nvim = { pkgs, ... }: {
    environment.systemPackages = [ (mkNvim pkgs) ];
  };

  flake.modules.darwin.nvim = { pkgs, ... }: {
    environment.systemPackages = [ (mkNvim pkgs) ];
  };

  flake.modules.home.nvim = _: {
    files.".config/nvim".source = ./nvim;
  };
}
