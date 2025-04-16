{
  lib,
  fetchFromGitHub,
  pkgs,
  craneLib,
}:
craneLib.buildPackage rec {
  pname = "codebook";
  version = "0.2.7";
  src = fetchFromGitHub {
    owner = "blopker";
    repo = "codebook";
    tag = "v${version}";
    hash = "sha256-DDh9yQn5KqsKTi0YP4ulxVMmZv74CgaLA7QF67TnfYY=";
  };

  nativeBuildInputs = with pkgs; [openssl.dev perl];
  buildInputs = [pkgs.openssl];

  cargoTestExtraArgs = "--no-run";

  meta = {
    changelog = "https://github.com/blopker/codebook/blob/${src.tag}/CHANGELOG.md";
    description = "Code Spell Checker";
    homepage = "https://github.com/blopker/codebook";
    license = lib.licenses.mit;
    mainProgram = "codebook";
  };
}
