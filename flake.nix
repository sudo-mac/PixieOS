{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";

    hyprland.url = "github:hyprwm/Hyprland";
    iio-hyprland.url = "github:JeanSchoeller/iio-hyprland";

    nixcord.url = "github:kaylorben/nixcord";

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
  };

  outputs = {
    self,
    home-manager,
    hyprland,
    nix-flatpak,
    nix-minecraft,
    nixcord,
    nixpkgs,
    nvf,
    stylix,
    ...
  } @ inputs: {
    nixosConfigurations = {
      alienix = nixpkgs.lib.nixosSystem {
        system = "x86-linux";

        specialArgs = {inherit inputs;};

        modules = [
          ./hosts/alienix/system
          ./modules/system

          home-manager.nixosModules.home-manager
          stylix.nixosModules.stylix
          nix-flatpak.nixosModules.nix-flatpak

          {
            home-manager = {
              useUserPackages = true;
              backupFileExtension = "backup";
              sharedModules = [
                nvf.homeManagerModules.default
                nixcord.homeModules.nixcord
              ];

              extraSpecialArgs = {inherit inputs;};
              users.dex.imports = [
                ./hosts/alienix/home
              ];
            };
          }
        ];
      };

      recovery = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [./recovery/configuration.nix];
      };
    };
  };
}
