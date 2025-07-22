{
  lib,
  fetchFromGitHub,
  pkgs,
  craneLib,
  fetchzip,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "kiorg";
  version = "1.0.0";
  src = fetchzip {
    url = "https://github.com/houqp/kiorg/releases/download/v1.0.0/kiorg-v${version}-x86_64-linux.zip";
    # sha256 = "c7bf97e90b9c0cdd7f0bd4c2c3af87f51974c6cfe3d6c74553866a4486826805";
    hash = "sha256-CJcUOsny+mcvNucvAU0stcxz9M6H1QFweQ8N0+HUWf4=";
  };
  dontConfigure = true;
  dontBuild = true;
  buildInputs = with pkgs; [
    openssl
    freetype
    fontconfig
    libGL
    libxkbcommon
    wayland
  ];
  installPhase = ''
    runHook preInstall
    install -m755 -D kiorg $out/bin/kiorg
    runHook postInstall
  '';
  preFixup = let
    libPath =
      lib.makeLibraryPath buildInputs;
  in ''
    patchelf \
      --add-needed libwayland-client.so \
      --add-needed libxkbcommon.so \
      --add-needed libGL.so \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" \
      $out/bin/kiorg
  '';
}
# craneLib.buildPackage rec {
#   pname = "kiorg";
#   version = "1.0.0";
#   src = fetchFromGitHub {
#     owner = "houqp";
#     repo = "kiorg";
#     tag = "v${version}";
#     hash = "sha256-GHaAy+jxzM4v1GT9hyFw26komVhY5QAXuCtKFwThor8=";
#   };
#   # nativeBuildInputs = with pkgs; [openssl.dev perl];
#   # buildInputs = [pkgs.openssl];
#   cargoTestExtraArgs = "--no-run";
#   meta = {
#     description = "A hacker's file manager with VIM inspired keybind ";
#     homepage = "https://github.com/houqp/kiorg";
#     license = lib.licenses.mit;
#     mainProgram = "kiorg";
#   };
# }

