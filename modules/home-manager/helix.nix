{pkgs, ...}: {
  programs = {
    helix = {
      enable = true;
      package = pkgs.unstable.helix;
      defaultEditor = true;
      settings = {
        theme = "gruvbox_dark_hard";
        editor = {
          line-number = "relative";
          rulers = [80];
          text-width = 80;
          color-modes = true;
          end-of-line-diagnostics = "hint";
          # soft-wrap = {
          #   enable = true;
          #   wrap-at-text-width = true;
          # };
        };
      };
      languages = {
        language-server.nixd = {
          command = "nixd";
          config = {
            formatting = {
              command = ["alejandra"];
            };
          };
        };
        language-server.typos = {
          command = "typos-lsp";
        };
        language-server.asm-lsp = {
          command = "asm-lsp";
        };

        language = [
          {
            name = "nix";
            language-servers = ["nixd"];
            formatter = {command = "alejandra";};
          }
          {
            name = "typst";
            language-servers = ["tinymist" "typos"];
            formatter = {command = "typstyle";};
          }
          {
            name = "nasm";
            language-servers = [ "asm-lsp" ];
          }
          {
            name = "gas";
            language-servers = [ "asm-lsp" ];
          }
        ];

        language-server.tinymist.config = {
          typstExtraArgs = ["main.typ"];
          exportPdf = "onType";
          outputPath = "$root/target/$dir/$name";
          formatterMode = "typstyle";
        };

      };
    };
  };
}
