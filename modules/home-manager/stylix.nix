{
# {
  gtk.iconTheme = {
      name = "Sweet-Mars";
  };
  stylix = {
    # iconTheme = {
    #   # package = pkgs.sweet-folders;
    #   # dark = "Sweet-Mars";
    #   # light = "Sweet-Mars";
    #   # package = pkgs.candy-icons;
    #   dark = "candy-icons";
    #   light = "candy-icons";
    # };
    targets = {
      helix.enable = false;
      firefox.profileNames = ["default" "school"];
    };
    targets.sway.useWallpaper = false;
    targets.wofi.enable = false;
    targets.nixcord.enable = false;
    targets.fcitx5.enable = true;
  };
  programs.nixcord = {
    enable = true;
    discord.enable = false;
    vesktop.enable = true;
    quickCss = ''
        * {
          border-radius: 0px;
        }
      '';
    config = {
      useQuickCss = true;
      themeLinks = [
        "https://raw.githubusercontent.com/shvedes/discord-gruvbox/refs/heads/main/gruvbox-dark.theme.css"
        "https://minidiscordthemes.github.io/Squared/Squared.theme.css"
      ];
      frameless = true;
      transparent = true;
      disableMinSize = true;
      plugins = {
        betterSettings.enable = true;
        betterFolders = {
          enable = true;
          sidebarAnim = false;
          closeOthers = true;
        };
        copyFileContents.enable = true;
        fixCodeblockGap.enable = true;
        gameActivityToggle.enable = true;
        imageLink.enable = true;
        imageZoom.enable = true;
        implicitRelationships.enable = true;
        memberCount.enable = true;
        messageLatency.enable = true;
        messageLogger.enable = true;
        noF1.enable = true;
        noMosaic.enable = true;
        noProfileThemes.enable = true;
        noTypingAnimation.enable = true;
        permissionsViewer.enable = true;
        plainFolderIcon.enable = true;
        platformIndicators.enable = true;
        replaceGoogleSearch = {
          enable = true;
          customEngineURL = "http://localhost:1111/search";
        };
        replyTimestamp.enable = true;
        roleColorEverywhere.enable = true;
        serverInfo.enable = true;
        showHiddenChannels.enable = true;
        showHiddenThings.enable = true;
        showMeYourName.enable = true;
        silentTyping.enable = true;
        typingIndicator.enable = true;
        userVoiceShow.enable = true;
        voiceChatDoubleClick.enable = true;
        viewIcons.enable = true;
        viewRaw.enable = true;
        webScreenShareFixes.enable = true;
        youtubeAdblock.enable = true;
        webKeybinds.enable = true;
      };
    };
  };
}
