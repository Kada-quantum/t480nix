# Custom packages
pkgs: {
  # voicevox = let
  #   git = pkgs.fetchgit {
  #     url = "https://github.com/NixOS/nixpkgs.git";
  #     sparseCheckout = [
  #       "pkgs/by-name/vo/voicevox"
  #       "pkgs/by-name/vo/voicevox-engine"
  #     ];
  #     # tag = "nixos-unstable";
  #     rev = "00c1e4a18675a620cc582dc81c744766e3badb6e";
  #     hash = "sha256-tZIz8Eujlmsw0HhYJ0OB9gK8RqyLezjFXz+WE1YSRSQ=";
  #   };
  #   voicevox-core = pkgs.callPackage ./voicevox-core.nix {};
  #   voicevox-engine = pkgs.callPackage "${git}/pkgs/by-name/vo/voicevox-engine/package.nix" {inherit voicevox-core;};
  # in
  #   pkgs.callPackage "${git}/pkgs/by-name/vo/voicevox/package.nix" {inherit voicevox-engine;};
  spotblock-rs = pkgs.callPackage ./spotblock-rs.nix {};
  open-webui = pkgs.unstable.callPackage ./open-webui.nix {};
}
