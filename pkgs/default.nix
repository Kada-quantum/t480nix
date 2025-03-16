# Custom packages
pkgs
: {
  voicevox = let
    git = pkgs.fetchgit {
      url = "https://github.com/NixOS/nixpkgs.git";
      sparseCheckout = [
        "pkgs/by-name/vo/voicevox"
        "pkgs/by-name/vo/voicevox-engine"
      ];
      # tag = "nixos-unstable";
      rev = "e238f8a86b5d75a8f5ca16084cc0e70b129bd8a7";
      hash = "sha256-tZIz8Eujlmsw0HhYJ0OB9gK8RqyLezjFXz+WE1YSRSQ=";
    };
    voicevox-core = pkgs.callPackage ./voicevox-core.nix {};
    voicevox-engine = pkgs.callPackage "${git}/pkgs/by-name/vo/voicevox-engine/package.nix" {inherit voicevox-core;};
  in
    pkgs.callPackage "${git}/pkgs/by-name/vo/voicevox/package.nix" {inherit voicevox-engine;};
  spotblock-rs = pkgs.callPackage ./spotblock-rs.nix {};
}
