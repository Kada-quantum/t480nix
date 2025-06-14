{pkgs, lib, ...}: {
  services.mpris-proxy.enable = true;
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        # fcitx5-mozc
        fcitx5-mozc-ut
        fcitx5-gtk
      ];
    };
  };
  xdg.configFile = {
    pixi = {
      target = "pixi/config.toml";
      text = "change-ps1 = false";
    };
    codebook = {
      target = "codebook/codebook.toml";
      text = "dictionaries = [\"en_us\", \"en_gb\"]";
    };
  };
  gtk.enable = true;
  programs = {
    bat.enable = true;
    carapace.enable = true;
    firefox = {
      enable = true;
      profiles.default = {
        isDefault = true;
      };
    };
    alacritty.enable = true;
    zsh = {
      enable = true;
      autocd = true;
      history = {
        expireDuplicatesFirst = true;
        size = 1000000;
      };
      initContent = lib.mkOrder 3000 ''
        # git repository greeter
        last_repository=
        check_directory_for_new_repository() {
          current_repository=$(git rev-parse --show-toplevel 2> /dev/null)

          if [ "$current_repository" ] && [ "$current_repository" != "$last_repository" ]; then
            onefetch
          fi
          last_repository=$current_repository
        }
        cd() {
          builtin cd "$@"
          check_directory_for_new_repository
        }
        z() {
          __zoxide_z "$@"
          check_directory_for_new_repository
        }
        zi() {
          __zoxide_zi "$@"
          check_directory_for_new_repository
        }

        # optional, greet also when opening shell directly in repository directory
        # adds time to startup
        # check_directory_for_new_repository
      '';
    };
    zoxide.enable = true;
    skim.enable = true;
    zathura.enable = true;
  };
}
