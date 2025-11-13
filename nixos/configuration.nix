# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  boot.kernelPackages = pkgs.linuxPackages;
  boot.kernelPatches = [
    {
      name = "Rust Support";
      patch = null;
      features = {
        rust = true;
      };
    }
  ];

  imports = [
    ../cachix.nix
    inputs.spicetify-nix.nixosModules.default
    outputs.nixosModules.stylix
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.wayland-ime
      outputs.overlays.unstable-packages
      inputs.fenix.overlays.default
      inputs.arduino-nix.overlay
      (inputs.arduino-nix.mkArduinoPackageOverlay (inputs.arduino-index + "/index/package_index.json"))
      (inputs.arduino-nix.mkArduinoLibraryOverlay (inputs.arduino-index + "/index/library_index.json"))
      (inputs.arduino-nix.mkArduinoPackageOverlay (inputs.arduino-index + "/index/package_heltec_esp32_index.json"))
      (inputs.arduino-nix.mkArduinoPackageOverlay (inputs.maixduino-index))
    ];
    config = {
      allowUnfree = true;
    };
  };

  # Users
  users = {
    users.kada = {
      useDefaultShell = true;
      isNormalUser = true;
      extraGroups = ["video" "input" "networkmanager" "wheel" "scanner" "lp" "dialout" "disk"];
      createHome = true;
      home = "/home/kada";
    };
    defaultUserShell = pkgs.zsh;
  };

  security = {
    polkit.enable = true;
    sudo.enable = false;
    sudo-rs.enable = true;
  };

  # Time zone
  time.timeZone = "Europe/Budapest";

  # Internationalisation properties
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = lib.unique (builtins.map (l: (lib.replaceStrings ["utf8" "utf-8" "UTF8"] ["UTF-8" "UTF-8" "UTF-8"] l) + "/UTF-8") (["C.UTF-8" "en_US.UTF-8" config.i18n.defaultLocale] ++ (lib.attrValues (lib.filterAttrs (n: v: n != "LANGUAGE") config.i18n.extraLocaleSettings))));
    # inputMethod = {
    #   enable = true;
    #   type = "fcitx5";
    #   fcitx5 = {
    #     waylandFrontend = true;
    #     addons = with pkgs; [
    #       # fcitx5-mozc
    #       fcitx5-mozc-ut
    #       fcitx5-gtk
    #     ];
    #   };
    # };
  };

  # services.xserver.desktopManager.runXdgAutostartIfNone = true;
  xdg = {
    portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };
  };

  console = {
    # font = "${pkgs.tamzen}/share/consolefonts/TamzenForPowerline10x20.psf";
    keyMap = "us";
  };

  fonts = {
    packages = with pkgs; [
      stix-two
      tamzen
      hasklig
      manrope
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      dejavu_fonts
      ipafont
      font-awesome
      rictydiminished-with-firacode
    ];
    fontconfig.defaultFonts = {
      monospace = [
        "Hasklig"
        "Ricty Diminished with FiraCode"
      ];
      sansSerif = [
        "Manrope"
        "IPAPGothic"
      ];
      serif = [
        "DejaVu Serif"
        "IPAPMincho"
      ];
      emoji = [
        "Awesome 6 Free"
        "Noto Color Emoji"
      ];
    };
  };

  # Networking
  networking.hostName = "knixa";
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "none";
  networking.useDHCP = false;
  networking.dhcpcd.enable = false;
  networking.nameservers = ["1.1.1.1" "1.0.0.1"];
  networking.firewall = {
    # if packets are still dropped, they will show up in dmesg
    logReversePathDrops = true;
    # wireguard trips rpfilter up
    extraCommands = ''
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
      ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
    '';
    extraStopCommands = ''
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
      ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
    '';
  };
  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.network.wait-online.enable = false;

  # Containers
  hardware.nvidia-container-toolkit.enable = true;
  virtualisation = {
    # oci-containers = {
    #   backend = "podman";
    #   containers = {
    #     arch = {
    #       # imageFile = pkgs.dockerTools.pullImage {
    #       #   imageName = "archlinux";
    #       #   imageDigest = "sha256:87a967f07ba6319fc35c8c4e6ce6acdb4343b57aa817398a5d2db57bd8edc731";
    #       #   finalImageTag = "base-devel";
    #       #   sha256 = "sha256-Wxw73KM7EErVFv4B26JCa4C7f8gARjA6w0fqCclNoZ4=";
    #       # };
    #       # imageFile = pkgs.dockerTools.buildImage {
    #       #   name = "archlinux";
    #       #   tag = "base-devel";
    #       #   fromImageName = "archlinux";
    #       #   fromImageTag = "base-devel";
    #       #   runAsRoot = ''
    #       #     #!/bin/sh
    #       #     pacman-key --init
    #       #     pacman -Syu
    #       #   '';
    #       # };
    #       # image = "docker.io/library/archlinux:base-devel";
    #       # hostname = "arch";
    #       # podman.user = "kada";
    #       # entrypoint = "/bin/bash";
    #       # autoStart = false;
    #     };
    #   };
    # };
    podman = {
      enable = true;
      package = pkgs.unstable.podman;
      # Create the default bridge network for podman
      # defaultNetwork.settings.dns_enabled = true;
    };
  };
  # systemd.services."podman-arch.service".serviceConfig = { Delegate = "yes"; };

  # Services
  services = {
    ratbagd.enable = true;
    searx = {
      enable = true;
      settings = {
        use_default_settings = true;
        server = {
          port = 1111;
          bind_address = "0.0.0.0";
          secret_key = builtins.readFile inputs.searx-secret;
          limiter = false;
          image_proxy = true;
        };
        ui.static_use_hash = true;
        search = {
          safe_search = 0;
          autocomplete = "";
          default_lang = "";
          formats = ["html" "json"];
        };
        redis.url = "redis://redis:6379/0";
      };
    };
    open-webui = {
      enable = true;
      package = pkgs.unstable.open-webui;
      environment = {
        STATIC_DIR = "/var/lib/open-webui/static";
        DATA_DIR = "/var/lib/open-webui/data";
        HF_HOME = "/var/lib/open-webui/hf_home";
        SENTENCE_TRANSFORMERS_HOME = "/var/lib/open-webui/transformers_home";
        ANONYMIZED_TELEMETRY = "False";
        DO_NOT_TRACK = "True";
        SCARF_NO_ANALYTICS = "True";
        OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
        OFFLINE_MODE = "True";
      };
    };
    ollama = {
      enable = true;
      acceleration = "cuda";
      package = pkgs.unstable.ollama.override {cudaArches = ["61"];};
      environmentVariables = {
        OLLAMA_NEW_ESTIMATES = "1";
        OLLAMA_FLASH_ATTENTION = "1";
      };
    };
    playerctld.enable = true;
    dbus.implementation = "broker";
    # ratbagd.enable = true;
    # Enable CUPS to print documents.
    printing = {
      enable = true;
      drivers = with pkgs; [gutenprint];
    };
    samba = {
      enable = true;
    };

    # Enable sound.
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    libinput = {
      enable = true;
      touchpad.naturalScrolling = false;
    };

    # Enable login manager
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
          user = "kada";
        };
      };
    };

    fwupd.enable = true;
    gnome.gnome-keyring.enable = true;
    blueman.enable = true;
    upower.enable = true;
    throttled.enable = lib.mkDefault true;
    tlp = {
      enable = true;
      settings = {
        CPU_ENERGY_PERF_POLICY_ON_BAT = "";
        CPU_ENERGY_PERF_POLICY_ON_AC = ""; #disabled for throttled
        START_CHARGE_THRESH_BAT0 = 50;
        STOP_CHARGE_THRESH_BAT0 = 60;
        START_CHARGE_THRESH_BAT1 = 50;
        STOP_CHARGE_THRESH_BAT1 = 60;
      };
    };
    tp-auto-kbbl.enable = true;
    wayland-pipewire-idle-inhibit = {
      enable = true;
      package = pkgs.unstable.wayland-pipewire-idle-inhibit;
      systemdTarget = "sway-session.target";
      settings = {
        verbosity = "INFO";
        media_minimum_duration = 30;
        idle_inhibitor = "wayland";
        sink_whitelist = [];
        node_blacklist = [
          {name = "spotify";}
        ];
      };
    };
  };

  # Programs
  programs = {
    chromium = {
      enable = true;
      enablePlasmaBrowserIntegration = false;
      plasmaBrowserIntegrationPackage = pkgs.plasma6Packages.plasma-browser-integration;
      extraOpts = {
        "PasswordManagerEnabled" = false;
      };
      extensions = [
        "egjidjbpglichdcondbcbdnbeeppgdph" # Trust Wallet
        "ponfpcnoihfmfllpaingbgckeeldkhle" # Enhancer for YouTube
        "nngceckbapebfimnlniiiahkandclblb" # BitWarden
      ];
    };
    starship = {
      enable = true;
      settings = {
        add_newline = false;

        format = ''$directory$nix_shell$git_branch$git_commit$git_state$git_status$docker_context$cmake$julia$rust$nodejs$python$conda$deno$typst$cmd_duration$jobs$status$line_break$shell'';

        battery.display = {
          threshold = 50;
          style = "bold red";
        };

        directory = {
          read_only = " RO";
          truncation_symbol = "⟨";
        };

        nix_shell = {
          symbol = "Nix:";
        };

        memory_usage = {
          disabled = false;
          threshold = -1;
          format = "$symbol[\${ram}(|\${swap})]($style) ";
          symbol = "M:";
        };

        python = {
          format = "\${symbol}[\${version}(E:\($virtualenv\)) ]($style)";
          symbol = "Py:";
        };

        rust.format = "R:[($version )]($style)";

        typst.format = "T:[($version )]($style)";

        deno.format = "D:[($version )]($style)";

        package.format = "P:[$version]($style) ";

        conda = {
          symbol = "Co:";
          format = "$symbol[$environment](dimmed green)";
        };

        status = {
          symbol = "χ";
          not_executable_symbol = "\\[NE\\]";
          not_found_symbol = "\\[NF\\]";
          sigint_symbol = "\\[ctrlC\\]";
          disabled = false;
        };

        time = {
          disabled = false;
          time_format = "%T%.f";
          format = ''[\[$time\]]($style) '';
        };

        shell = {
          format = "[$indicator](dimmed white)";
          zsh_indicator = "ζ ";
          bash_indicator = "β ";
          fish_indicator = "φ ";
          powershell_indicator = "ψ ";
          nu_indicator = "ν ";
          unknown_indicator = "Λ ";
          disabled = false;
        };

        shlvl = {
          symbol = "η:";
          disabled = false;
        };

        hostname = {
          ssh_only = false;
          style = "orange";
          format = "[$hostname]($style) ";
          disabled = false;
        };

        username = {
          style_user = "cyan";
          style_root = "red bold";
          format = "[$user]($style):";
          disabled = false;
          show_always = true;
        };

        git_branch = {
          symbol = "βγ:";
          format = "$symbol[$branch]($style) ";
        };

        git_commit = {
          tag_disabled = false;
          only_detached = false;
          tag_symbol = "τ:";
        };

        git_status = {
          staged = "+$count";
          ahead = "↑$ahead_count";
          behind = "↓$behind_count";
          deleted = "Χ";
        };

        nodejs = {
          format = "$symbol[$version ]($style)";
          symbol = "JS:";
        };

        cmake = {
          format = "$symbol[$version ]($style)";
          symbol = "Cm:";
        };

        docker_context = {
          format = "$symbol[$context]($style) ";
          symbol = "Dock:";
        };

        julia = {
          format = "$symbol[$version ]($style)";
          symbol = "Jul:";
        };

        character = {
          success_symbol = "[λ⁅](bold blue)";
          error_symbol = "[λ!⁅](bold red) ";
          vicmd_symbol = "[λ⁅](bold green) ";
        };
      };
    };
    nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep 3 --keep-since 3d";
      };
      flake = "/etc/flakes/nixos";
    };
    git = {
      enable = true;
      lfs.enable = true;
    };
    zsh = {
      enable = true;
      histSize = 10000;
      enableLsColors = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      shellInit = "fastfetch";
      syntaxHighlighting = {
        enable = true;
        highlighters = [
          "main"
          "brackets"
          "pattern"
          "regexp"
        ];
      };
    };
    sway = {
      enable = true;
      wrapperFeatures.gtk = false;
    };
    firefox = {
      enable = true;
      preferences = {
        "browser.ml.chat.enabled" = true;
        "browser.ml.chat.sidebar" = true;
        "browser.ml.chat.hideLocalhost" = false;
        "browser.ml.chat.provider" = "http://localhost:8080/?model=gemma3:latest&temporary-chat=true";
        "browser.ml.linkPreview.enabled" = true;
      };
      # Check about:policies#documentation for options.
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisablePocket = true;
        DontCheckDefaultBrowser = true;
        DisplayBookmarksToolbar = "newtab";
        DisplayMenuBar = "default-off";
        SearchBar = "unified";
        # Check about:support for extension/add-on ID strings.
        ExtensionSettings = {
          # "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
          # uBlock Origin:
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
            default_area = "menupanel";
          };
          # Privacy Badger:
          "jid1-MnnxcxisBPnSXQ@jetpack" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
            installation_mode = "force_installed";
          };
          # Enhancer for YouTube:
          "enhancerforyoutube@maximerf.addons.mozilla.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/enhancer-for-youtube/";
            installation_mode = "force_installed";
          };
          # Dark Reader:
          "addon@darkreader.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
            installation_mode = "force_installed";
          };
          # Firefox Multi Account Containers
          "@testpilot-containers" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/multi-account-containers/latest.xpi";
            installation_mode = "force_installed";
            default_area = "menupanel";
          };
          # ff2mpv
          "ff2mpv@yossarian.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ff2mpv/latest.xpi";
            installation_mode = "force_installed";
          };
          # Port Authority
          "{6c00218c-707a-4977-84cf-36df1cef310f}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/port-authority/latest.xpi";
            installation_mode = "force_installed";
          };
          # Sidebery
          "{3c078156-979c-498b-8990-85f7987dd929}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/sidebery/latest.xpi";
            installation_mode = "force_installed";
          };
        };
      };
      nativeMessagingHosts.packages = with pkgs; [
        ff2mpv-rust
        fx-cast-bridge
      ];
    };
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
    gamemode.enable = true;
  };

  environment.systemPackages = with pkgs; [
    obs-studio
    harper
    unstable.ramalama
    eza
    piper
    freecad-qt6
    kicad
    kiorg
    sic-image-cli
    # scenebuilder23
    android-tools
    onefetch
    waytrogen
    swww
    mpvpaper
    libnotify
    jaq
    (lib.hiPrio pkgs.uutils-coreutils-noprefix)
    pwvucontrol
    sway-easyfocus
    codebook
    markdown-oxide
    nb
    unstable.anki-bin
    imv
    iamb
    rio
    clang
    mold-wrapped
    spotblock-rs
    python3Minimal
    (
      wrapArduinoCLI
      {
        libraries = with inputs.arduino-nix;
        with arduinoLibraries; [
          (latestVersion StreamUtils)
          (latestVersion EspSoftwareSerial)
          (latestVersion HotButton)
          (latestVersion RadioLib)
          (latestVersion ArduinoLog)
          (latestVersion TinyGPSPlus)
          (latestVersion FastIMU)
          (latestVersion arduinoLibraries."Adafruit BMP280 Library")
          (latestVersion arduinoLibraries."Adafruit Unified Sensor")
          (latestVersion arduinoLibraries."Adafruit BusIO")
          (latestVersion arduinoLibraries."ESP8266 and ESP32 OLED driver for SSD1306 displays")
          (latestVersion arduinoLibraries."Heltec ESP32 Dev-Boards")
          (latestVersion arduinoLibraries."Heltec_ESP32_LoRa_v3")
        ];

        packages = with inputs.arduino-nix;
        with arduinoPackages.platforms; [
          (latestVersion arduino.avr)
          (latestVersion Heltec-esp32.esp32)
          (latestVersion Maixduino.k210)
        ];
      }
    )
    asm-lsp
    tailspin
    arduino-language-server
    sweet-folders
    clang-tools
    candy-icons
    gtk2
    gtk3
    gtk4
    unstable.helix
    bat
    zathura
    fenix.stable.completeToolchain
    lldb
    carapace
    gh
    gitui
    delta
    unstable.gitoxide
    zoxide
    wofi
    waybar
    nix-output-monitor
    typst
    typstyle
    tinymist
    strace
    strace-analyzer
    pciutils
    procs
    ripgrep
    xh
    hyprpolkitagent
    adwaita-icon-theme
    lutris
    greetd.tuigreet
    grim
    slurp
    wl-clipboard
    mako
    alacritty
    fastfetch
    bottom
    dust
    dysk
    inkscape
    unstable.gimp3
    brave
    (prismlauncher.override {
      jdks = [jdk23];
    })
    cubiomes-viewer
    libreoffice-fresh
    hunspell
    hunspellDicts.en_GB-large
    hunspellDicts.es-es
    vlc
    vulkan-tools
    autotiling-rs
    discordo
    alejandra
    nixd
    mpv
    signal-desktop
    spotify
    servo
    easyeffects
    unstable.voicevox
  ];

  # Env Variables
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    _JAVA_AWT_WM_NONREPARENTING = 1;
    INPUT_METHOD = "fcitx";
    QT_IM_MODULE = "fcitx";
    GTK_IM_MODULE = "wayland";
    XMODIFIERS = "@im=fcitx";
    XIM_SERVERS = "fcitx";
  };

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 6;
  boot.initrd.systemd.network.wait-online.enable = false;

  # Hardware
  services.xserver.videoDrivers = ["nvidia"];
  hardware = {
    sane.enable = true;
    bluetooth.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [intel-compute-runtime intel-media-driver nvidia-vaapi-driver libva-vdpau-driver];
    };
    printers = {
      ensurePrinters = [
        {
          name = "Canon-G2410";
          description = "Canon G2410";
          location = "knixa";
          deviceUri = "usb://Canon/G2010%20series?serial=B2CED4&interface=1";
          model = "gutenprint.${lib.versions.majorMinor (lib.getVersion pkgs.gutenprint)}://bjc-G2000-series/expert";
          ppdOptions = {
            PageSize = "A4";
          };
        }
        {
          name = "school";
          description = "school";
          location = "NORDANGLIA";
          deviceUri = "smb://10.75.4.20/BUD-FollowMe-Konica";
          model = "drv:///cupsfilters.drv/pwgrast.ppd";
          ppdOptions = {
            PageSize = "A4";
            PwgRasterDocumentType = "Cmyk_8";
            PrintQuality = "5";
          };
        }
      ];
      ensureDefaultPrinter = "Canon-G2410";
    };

    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      open = false;
      modesetting.enable = true;
      prime = {
        sync.enable = true;
        nvidiaBusId = "PCI:1:0:0";
        intelBusId = "PCI:0:2:0";
      };
      nvidiaSettings = true;
    };
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  specialisation = {
    java.configuration = {
      system.nixos.tags = ["legacy_cgroup"];
      boot.kernelParams = ["SYSTEMD_CGROUP_ENABLE_LEGACY_FORCE=1" "systemd.unified_cgroup_hierarchy=0"];
    };
    javaigpu.configuration = {
      system.nixos.tags = ["legacy_cgroup_igpu"];
      boot.kernelParams = ["SYSTEMD_CGROUP_ENABLE_LEGACY_FORCE=1" "systemd.unified_cgroup_hierarchy=0"];
      boot.extraModprobeConfig = ''
        blacklist nouveau
        options nouveau modeset=0
      '';
      powerManagement.cpuFreqGovernor = "powersave";
      services.udev.extraRules = ''
        # Remove NVIDIA USB xHCI Host Controller devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
        # Remove NVIDIA USB Type-C UCSI devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
        # Remove NVIDIA Audio devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
        # Remove NVIDIA VGA/3D controller devices
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
      '';
      boot.blacklistedKernelModules = ["nouveau" "nvidia" "nvidiafb" "nvidia_drm" "nvidia-uvm" "nvidia_modeset"];
      services.throttled.enable = false;
      networking.networkmanager.wifi.powersave = true;
    };
    igpu.configuration = {
      system.nixos.tags = ["igpu"];
      boot.extraModprobeConfig = ''
        blacklist nouveau
        options nouveau modeset=0
      '';
      powerManagement.cpuFreqGovernor = "powersave";
      services.udev.extraRules = ''
        # Remove NVIDIA USB xHCI Host Controller devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
        # Remove NVIDIA USB Type-C UCSI devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
        # Remove NVIDIA Audio devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
        # Remove NVIDIA VGA/3D controller devices
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
      '';
      boot.blacklistedKernelModules = ["nouveau" "nvidia" "nvidiafb" "nvidia_drm" "nvidia-uvm" "nvidia_modeset"];
      boot.kernelParams = [];
      services.throttled.enable = false;
      networking.networkmanager.wifi.powersave = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes dynamic-derivations";
      # disable global registry -> avail only explicit input specification
      flake-registry = "";
    };
    # disable channels -> only rely on pined versions
    channel.enable = false;

    # make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
