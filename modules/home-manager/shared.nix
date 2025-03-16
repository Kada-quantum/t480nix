{
  xdg.configFile.pixi = {
    target = "pixi/config.toml";
    text = "change-ps1 = false";
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
    waybar.enable = true;
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
  };
  qt.enable = true;
}
