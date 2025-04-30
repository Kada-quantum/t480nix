lib: {
  stylix = import ./stylix.nix;
  helix = import ./helix.nix;
  git = import ./git.nix;
  sway = import ./sway.nix lib;
  shared = import ./shared.nix;
}
