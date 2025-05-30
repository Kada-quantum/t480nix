{pkgs, ...}: {
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
    };
    zoxide.enable = true;
    skim.enable = true;
    zathura.enable = true;
  };
}
