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
          rulers = [78];
          text-width = 78;
          color-modes = true;
          bufferline = "multiple";
          cursorline = true;
          cursorcolumn = true;
          end-of-line-diagnostics = "disable";
          lsp = {
            display-progress-messages = true;
            display-inlay-hints = true;
          };
          indent-guides.render = true;
          inline-diagnostics = {
            cursor-line = "hint";
            other-lines = "warning";
          };
          statusline = {
            left = ["mode" "spinner" "version-control" "file-type" "file-name" "read-only-indicator" "file-modification-indicator"];
            center = [];
            right = ["diagnostics" "selections" "register" "position" "total-line-numbers" "file-encoding" "file-line-ending"];
          };
          # soft-wrap = {
          #   enable = true;
          #   wrap-at-text-width = true;
          # };
        };
      };
      languages = {
        language-server.nixd.config = {
          formatting = {
            command = ["alejandra"];
          };
        };
        language-server.codebook = {
          command = "codebook-lsp";
          args = ["serve"];
        };
        language-server.tinymist.config = {
          typstExtraArgs = ["main.typ"];
          exportPdf = "onType";
          outputPath = "$root/target/$dir/$name";
          formatterMode = "typstyle";
        };
        language-server.deno-lsp = {
          command = "deno";
          args = ["lsp"];
          config.deno.enable = true;
        };
        language = [
          {
            name = "nix";
            language-servers = ["nixd"];
            formatter = {command = "alejandra";};
          }
          {
            name = "typst";
            language-servers = ["tinymist" "codebook"];
            formatter = {command = "typstyle";};
          }
          {
            name = "markdown";
            language-servers = ["markdown-oxide" "marksman" "codebook"];
          }
          {
            name = "typescript";
            roots = ["deno.json" "deno.jsonc" "package.json"];
            file-types = ["ts" "tsx"];
            auto-format = true;
            language-servers = ["deno-lsp"];
          }
          {
            name = "javascript";
            roots = ["deno.json" "deno.jsonc" "package.json"];
            file-types = ["js" "jsx"];
            auto-format = true;
            language-servers = ["deno-lsp"];
          }
        ];
      };
    };
  };
}
