lib: let
  modifier = "Mod1";
in {
  programs.waybar = {
    enable = true;
    settings = [
      {
        fixed-center = false;
        modules-left = [
          "sway/workspaces"
          "sway/mode"
          "sway/scratchpad"
        ];
        modules-center = [
          "sway/window"
        ];
        modules-right = [
          "keyboard-state"
          "wireplumber"
          "network"
          "cpu"
          "memory"
          "temperature"
          "backlight"
          "battery"
          "battery#BAT0"
          "battery#BAT1"
          "clock"
          "tray"
        ];
        cpu = {
          format = "CPU:{usage}%";
        };
        memory = {
          format = "MEM:{}%";
        };
        temperature = {
          format = "{temperatureK}K";
        };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "BAT:{capacity}%";
          format-full = "BAT:{capacity}%";
          format-charging = "BAT:{capacity}%C";
          format-plugged = "BAT:{capacity}%P";
          format-alt = "{time}";
        };
        "battery#BAT0" = {
          bat = "BAT0";
          format = "{icon}";
          format-full = "{icon}";
          format-charging = "{icon}";
          format-plugged = "{icon}";
          format-alt = "{time}";
          format-icons = ["▁" "▃" "▄" "▅" "▆"];
          tooltip-format = "BAT0:{capacity}%";
        };
        "battery#BAT1" = {
          bat = "BAT1";
          format = "{icon}";
          format-full = "{icon}";
          format-charging = "{icon}";
          format-plugged = "{icon}";
          format-alt = "{time}";
          format-icons = ["▁" "▃" "▄" "▅" "▆"];
          tooltip-format = "BAT1:{capacity}%";
        };
        keyboard-state = {
          numlock = true;
          capslock = true;
          format = "{name}:{icon}";
          format-icons = {
            locked = "locked";
            unlocked = "unlocked";
          };
        };
        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
        };
        clock = {
          format-alt = "{:%b %d %a %T}";
          tooltip-format = "{:%b %d %a %T}\\n{calendar}";
        };
        network = {
          format-wifi = "wifi:{essid}:{signalStrength}%";
          format-ethernet = "eth:{ipaddr}/{cidr}";
          tooltip-format = "{ifname} via {gwaddr}";
          format-linked = "{ifname}:NoIP";
          format-disconnected = "Disconnected";
          format-alt = "{ifname}={ipaddr}/{cidr}";
        };
        wireplumber = {
          scroll-step = 1;
          on-click = "pwvucontrol";
        };
      }
    ];
  };
  services.mako.enable = true;
  services.mako.defaultTimeout = 3000;
  services.wob.enable = true;
  wayland.windowManager.sway = {
    enable = true;
    config = {
      inherit modifier;
      defaultWorkspace = "workspace number 1";
      gaps = {
        inner = 10;
        outer = 4;
        smartGaps = true;
      };
      focus.mouseWarping = "container";
      bars = [{command = "waybar";}];
      menu = "wofi -S drun -D key_expand=Tab";
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
      keybindings = lib.mkOptionDefault {
        "${modifier}+Shift+e" = "exec swaymsg exit";
        "${modifier}+Tab" = "exec sway-easyfocus";
        "XF86MonBrightnessDown" = "exec brightnessctl set 5%- | sed -En 's/.*\\(([0-9]+)%\\).*/\\1/p' > $(systemctl show --user wob.socket -p Listen | sed 's/Listen=//' | cut -d' ' -f1)";
        "XF86MonBrightnessUp" = "exec brightnessctl set 5%+ | sed -En 's/.*\\(([0-9]+)%\\).*/\\1/p' > $(systemctl show --user wob.socket -p Listen | sed 's/Listen=//' | cut -d' ' -f1)";
        "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+ && wpctl get-volume @DEFAULT_AUDIO_SINK@ | sed 's/[^0-9]//g' > $(systemctl show --user wob.socket -p Listen | sed 's/Listen=//' | cut -d' ' -f1)";
        "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%- && wpctl get-volume @DEFAULT_AUDIO_SINK@ | sed 's/[^0-9]//g' > $(systemctl show --user wob.socket -p Listen | sed 's/Listen=//' | cut -d' ' -f1)";
        "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && (wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED && echo 0 > $(systemctl show --user wob.socket -p Listen | sed 's/Listen=//' | cut -d' ' -f1)) || wpctl get-volume @DEFAULT_AUDIO_SINK@ | sed 's/[^0-9]//g' > $(systemctl show --user wob.socket -p Listen | sed 's/Listen=//' | cut -d' ' -f1)";
        "XF86AudioMicMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle && (wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q MUTED && echo 0 > $(systemctl show --user wob.socket -p Listen | sed 's/Listen=//' | cut -d' ' -f1)) || wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | sed 's/[^0-9]//g' > $(systemctl show --user wob.socket -p Listen | sed 's/Listen=//' | cut -d' ' -f1)";
        "XF86AudioPlay" = "exec playerctl start-pause";
        "XF86AudioPause" = "exec playerctl start-pause";
        "XF86AudioNext" = "exec playerctl next";
      };
      window.border = 0;
      window.titlebar = false;
    };
  };
}
