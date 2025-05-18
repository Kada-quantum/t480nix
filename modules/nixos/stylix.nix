{
  pkgs,
  inputs,
  config,
  ...
}: {
  programs.spicetify = let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
  in {
    enable = true;
    spicetifyPackage = pkgs.unstable.spicetify-cli;
    enabledExtensions = [
      {
        src = "${pkgs.fetchFromGitHub {
          owner = "ohitstom";
          repo = "spicetify-extensions";
          rev = "0fa2e593742011a29f8ec54c32bf642205ce82ff";
          hash = "sha256-w8viHMXhuXIlo1WJ94Jo2bWtYQr1RGviXZhVVm+rvns=";
        }}/pixelatedImages";
        name = "pixelatedImages.js";
      }
    ];
    # enabledExtensions = with spicePkgs.extensions; [
    #   adblock
    #   hidePodcasts
    #   shuffle # shuffle+ (special characters are sanitized out of extension names)
    # ];
    wayland = true;
    theme = spicePkgs.themes.text;
    # colorScheme = "Gruvbox";
    colorScheme = "custom";
    customColorScheme = with config.lib.stylix.colors; {
      "accent" = "${green}";
      "accent-active" = "${green}";
      "accent-inactive" = "${base00}";
      "banner" = "${green}";
      "border-active" = "${green}";
      "border-inactive" = "${base01}";
      "header" = "${base03}";
      "highlight" = "${base03}";
      "main" = "${base00}";
      "notification" = "${cyan}";
      "notification-error" = "${red}";
      "subtext" = "${base04}";
      "text" = "${base07}";
    };
  };
  stylix = {
    enable = true;
    image = ./wallpaper.jpeg;
    polarity = "dark";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/horizon-light.yaml";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    override = {
      # from gruvbox light hard
      base08 = "9d0006"; # red
      base09 = "af3a03"; # orange
      base0A = "b57614"; # yellow
      base0B = "79740e"; # green
      base0C = "427b58"; # aqua/cyan
      base0D = "076678"; # blue
      base0E = "8f3f71"; # purple
      base0F = "d65d0e"; # brown
    };
    opacity = {
      terminal = 0.8;
      # application = 1.0;
      desktop = 0.9;
      popups = 0.8;
    };
    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };

      sansSerif = {
        package = pkgs.manrope;
        name = "Manrope";
      };

      monospace = {
        package = pkgs.hasklig;
        name = "Hasklig";
      };

      emoji = {
        package = pkgs.font-awesome;
        name = "Awesome 6 Free";
      };

      sizes = {
        applications = 14;
        desktop = 12;
        popups = 12;
        terminal = 14;
      };
    };
    cursor = {
      package = pkgs.simp1e-cursors;
      name = "Simp1e-Gruvbox-Dark";
    };
    targets.spicetify.enable = false;
  };
}
