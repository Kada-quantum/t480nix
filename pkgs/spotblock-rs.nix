{
  pkgs,
  makeDesktopItem,
  writeShellApplication,
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  pname = "spotblock-rs";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "KivalM";
    repo = "spotblock-rs";
    # url = "https://github.com/KivalM/spotblock-rs.git";
    rev = "0b843bc85140e3b412425b43de9dd6016ca1fef5";
    fetchSubmodules = false;
    hash = "sha256-8WJ+GRWSkMpJfR59E2ZuMfaYXL6fqpCeMw45s4MwLGk=";
  };

  cargoHash = "sha256-PfGgv2lD7OZ0azvLteTaUiD57byfC49QDcFkZ2ufiOY=";

  postInstall = let
    script = writeShellApplication {
      name = "spotblock-run";
      runtimeInputs = with pkgs; [ killall ];
      text = ''
        spotblock-rs &
        spotify
        killall spotblock-rs
      '';
    };
    desktopEntry = makeDesktopItem rec {
      name = "Spotblock";
      desktopName = name;
      exec = "spotblock-run";
      comment="Launch spotify with blocked ads";
      terminal = false;
      type = "Application";
      icon = "Spotify";
      categories = ["Music"];
    };
  in ''
    install -Dm555 ${script}/bin/spotblock-run $out/bin/spotblock-run
    mkdir -p $out/share/applications
    install -Dm555 ${desktopEntry}/share/applications/Spotblock.desktop $out/share/applications/spotblock.desktop
  '';

  meta = {
    changelog = "https://github.com/KivalM/spotblock-rs";
    description = "A spotify advertisment muter for Pipewire";
    homepage = "https://github.com/KivalM/spotblock-rs";
    license = with lib.licenses; [
      gpl3
    ];
  };
}
