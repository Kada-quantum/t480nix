{pkgs, fetchgit, voicevox-core}:
{
    voicevox-engine = pkgs.callPackage "${fetchgit {
      url = "https://github.com/NixOS/nixpkgs.git";
      sparseCheckout = "pkgs/by-name/vo/voicevox-engine";
      ref = "nixos-unstable";
      rev = "e238f8a86b5d75a8f5ca16084cc0e70b129bd8a7";
    }}/pkgs/by-name/vo/voicevox-engine/package.nix" {inherit voicevox-core;};
}
