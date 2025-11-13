# Custom packages
{
  pkgs,
  craneLib,
}: {
  spotblock-rs = pkgs.callPackage ./spotblock-rs.nix {inherit craneLib;};
  # codebook = pkgs.callPackage ./codebook.nix {inherit craneLib;};
  scenebuilder23 = pkgs.callPackage ./scenebuilder.nix {};
  kiorg = pkgs.callPackage ./kiorg.nix {inherit craneLib;};
}
