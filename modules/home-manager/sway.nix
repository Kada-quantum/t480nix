{
  services.mako.enable = true;
  services.mako.defaultTimeout = 3000;
  wayland.windowManager.sway = {
    enable = true;
    config = {
      defaultWorkspace = "workspace number 1";
      gaps = {
        inner = 10;
        outer = 4;
        smartGaps = true;
      };
      bars = [{command = "waybar";}];
      menu = "wofi -S drun -D key_expand=Tab";
      modifier = "Mod1";
      terminal = "alacritty";
      startup = [
        {
          command = "autotiling-rs";
          always = true;
        }
        {
          command = "fcitx5";
        }
        {
          command = "mako";
        }
      ];
      window.border = 0;
      window.titlebar = false;
    };
  };
}
