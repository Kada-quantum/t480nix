# https://nixos.wiki/wiki/Overlays
{inputs, ...}: {
  # Includes custom packages in pkgs
  additions = final: _prev: let
    craneLib = (inputs.crane.mkLib final.pkgs).overrideToolchain (p: final.pkgs.fenix.minimal.toolchain);
  in
    import ../pkgs {
      pkgs = final.pkgs;
      inherit craneLib;
    };

  modifications = final: prev: {
    lutris = prev.lutris.override {
      extraPkgs = pkgs: [pkgs.gamescope];
    };
    # pythonPackagesExtensions =
    #   prev.pythonPackagesExtensions
    #   ++ [
    #     (
    #       python-final: python-prev: {
    #         # torch = python-prev.torch.override {
    #         #   cudaSupport = false;
    #         #   cudnnSupport = false;
    #         # };
    #         torch = python-final.torch-bin;
    #         jax = python-prev.jax.overridePythonAttrs (attrs: {
    #           doCheck = false;
    #           doInstallCheck = false;
    #           # checkPhase = "";
    #         });
    #       }
    #     )
    #   ];

    # voicevox-engine = prev.voicevox-engine.override {
    #   cudaSupport = false;
    #   cudnnSupport = false;
    # };
    ollama = prev.ollama.overrideAttrs (attrs: {
      cudaSupport = true;
      cudnnSupport = true;
    });
  };

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
      overlays = [
        (final: prev: {
          python312 = prev.python312.override {
            packageOverrides = pyself: pysuper: {
              gcp-storage-emulator = pysuper.gcp-storage-emulator.overrideAttrs (attrs: {
                pytestFlagsArray = [
                  # AssertionError: BadRequest not raised
                  "--deselect=tests/test_server.py::ObjectsTests::test_invalid_crc32c_hash"
                ];
              });
            };
          };
        })
      ];
    };
  };

  # Enable wayland IME for chromium and electron programs
  wayland-ime = final: prev: {
    brave = prev.brave.override {
      commandLineArgs = [
        "--ignore-gpu-blocklist"
        "--enable-zero-copy"
        "--enable-wayland-ime"
        "--wayland-text-input-version=3"
      ];
    };
    vesktop = prev.pkgs.symlinkJoin {
      name = "vesktop";
      paths = [prev.vesktop];
      buildInputs = [prev.pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/vesktop \
          --add-flags "--enable-wayland-ime --wayland-text-input-version=3"
      '';
    };
    signal-desktop = prev.pkgs.symlinkJoin {
      name = "signal-desktop";
      paths = [prev.signal-desktop];
      buildInputs = [prev.pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/signal-desktop \
          --add-flags "--enable-wayland-ime --wayland-text-input-version=3"
      '';
    };
    voicevox = prev.pkgs.symlinkJoin {
      name = "vesktop";
      paths = [prev.voicevox];
      buildInputs = [prev.pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/voicevox \
          --add-flags "--enable-wayland-ime --wayland-text-input-version=3"
      '';
    };
  };
}
