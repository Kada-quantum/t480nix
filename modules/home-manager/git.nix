{
  programs = {
    git = {
      enable = true;
      delta.enable = true;
      userName = "Kada Ozaki";
      userEmail = "kada02ak1@outlook.com";
      extraConfig = {
        init.defaultBranch = "main";
      };
    };
    gitui.enable = true;
    gh.enable = true;
  };
}
