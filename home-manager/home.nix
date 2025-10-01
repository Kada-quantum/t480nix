{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
  imports = [
    outputs.homeManagerModules.sway
    inputs.textfox.homeManagerModules.default
  ];

  programs.firefox = {
    profiles.school = {
      id = 1;
    };
  };

  textfox = {
    enable = true;
    profiles = ["default" "school"];
    config = {
      displayTitles = false;
      font = {
        family = "Hasklig";
        accent = config.lib.stylix.colors.withHashtag.base09;
      };
      newtabLogo = ''
        ░▒▓█▓▒░░▒▓█▓▒░▒▓███████▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓██████▓▒░
        ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░
        ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░
        ░▒▓███████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓██████▓▒░░▒▓████████▓▒░
        ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░
        ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░
        ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░
      '';
      displayNavButtons = true;
      tabs.vertical.margin = "0px";
      background = {
        color = config.lib.stylix.colors.withHashtag.base00;
      };
      border = {
        color = config.lib.stylix.colors.withHashtag.base01;
        transition = "none";
      };
      icons = {
        toolbar.extensions.enable = true;
        context.extensions.enable = true;
      };
      extraConfig = ''
        @-moz-document regexp("^moz-extension://.*?/sidebar/sidebar.html") {
          .Tab .fav, .Tab .fav-icon {
            filter: grayscale(100%) !important;
          }
        }
        @-moz-document url("about:home"), url("about:newtab") {
          .logo-and-wordmark-wrapper {
            height: 256px;
            .wordmark {
              height: 256px;
            }
          }
        }
      '';
    };
  };

  xdg = {
    configFile.iamb = {
      enable = true;
      target = "iamb/config.toml";
      text = let
        matrix = builtins.readFile inputs.matrix-account;
      in ''
        [profiles.kada]
        user_id = "${matrix}"
        [settings]
        image_preview = {}
        [settings.notifications]
        enabled = true
      '';
    };
    desktopEntries.firefox = {
      # enable = true;
      # name = "firefox";
      # desktopName = "Firefox";
      name = "Firefox";
      genericName = "Web Browser";
      icon = "firefox";
      exec = "firefox --name firefox %U";
      categories = ["Network" "WebBrowser"];
      mimeType = ["text/html" "text/xml" "application/xhtml+xml" "application/vnd.mozilla.xul+xml" "x-scheme-handler/http" "x-scheme-handler/https"];
      startupNotify = true;
      terminal = false;
      # startupWMClass = "firefox";
      actions = {
        new-private-window = {
          exec = "firefox --private-window %U";
          name = "New Private Window";
        };
        new-window = {
          exec = "firefox --new-window %U";
          name = "New Window";
        };
        school = {
          exec = "firefox --P school %U";
          name = "School Profile";
        };
        profile-manager-window = {
          exec = "firefox --ProfileManager %U";
          name = "Profile Manager";
        };
      };
    };
  };
  programs.home-manager.enable = true;
  home = {
    file = {
      arduino = {
        target = ".arduino15/arduino-cli.yaml";
        text = builtins.toJSON {
          sketch.always_export_binaries = true;
        };
        # "
        # directories:
        #   data: /nix/store/3m6whcgp2zf1cir2x656bwnn7lhwz77q-arduino-data
        #   user: /nix/store/b3h9x94zls588n5rsydnjkxsa2yf96wg-arduino-libraries
        # updater:
        #   enable_notification: false
        # sketch:
        #   always_export_binaries: true
        # ";
      };
    };
    sessionVariables = {
      EDITOR = "hx";
    };
    username = "kada";
    homeDirectory = "/home/kada";
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "25.05";
  };
}
