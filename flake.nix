{
  description = "Kada's NixOS system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable-small";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    crane.url = "github:ipetkov/crane";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    arduino-nix.url = "github:bouk/arduino-nix";
    arduino-index = {
      url = "github:bouk/arduino-indexes";
      flake = false;
    };
    maixduino-index = {
      url = "http://dl.sipeed.com/MAIX/Maixduino/package_Maixduino_k210_index.json";
      flake = false;
      # sha256 = "bea1d6d47977cd16c93edcd25a8ca16410a89880dd7f7f008d88b170ef28c860";
    };
    matrix-account = {
      url = "path:/etc/nixos/matrix.txt";
      flake = false;
    };
    searx-secret = {
      url = "path:/etc/nixos/searx.secret";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    stylix,
    ...
  } @ inputs: let
    inherit (self) outputs;
    # Supported systems
    systems = [
      # "aarch64-linux"
      # "i686-linux"
      "x86_64-linux"
      # "aarch64-darwin"
      # "x86_64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    # Custom Packages
    packages = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      craneLib = (inputs.crane.mkLib pkgs).overrideToolchain (p: p.inputs.fenix.packages.${system}.minimal.toolchain);
    in
      import ./pkgs {
        inherit pkgs;
        inherit craneLib;
      });
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    overlays = import ./overlays {inherit inputs;};
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;

    nixosConfigurations = {
      # Lenovo Thinkpad T480
      knixa = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.backupFileExtension = "back";
            home-manager.extraSpecialArgs = {inherit inputs outputs;};
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.kada = import ./home-manager/home.nix;
            home-manager.sharedModules = [
              outputs.homeManagerModules.stylix
              outputs.homeManagerModules.helix
              outputs.homeManagerModules.git
              outputs.homeManagerModules.shared
            ];
          }
          stylix.nixosModules.stylix
        ];
      };
    };
  };
}
