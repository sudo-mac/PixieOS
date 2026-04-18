{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    hyprland.url = "github:hyprwm/Hyprland";
    iio-hyprland.url = "github:JeanSchoeller/iio-hyprland";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    nixpkgs-droid = {
      url = "github:nixos/nixpkgs/88d3861";
    };

    nixcord.inputs.nixpkgs.follows = "nixpkgs";
    nixcord.url = "github:kaylorben/nixcord";
    nvf.inputs.nixpkgs.follows = "nixpkgs";
    nvf.url = "github:notashelf/nvf";
    rust-overlay.url = "github:oxalica/rust-overlay";
    stylix.url = "github:danth/stylix";
  };

  outputs =
    {
      self,
      home-manager,
      hyprland,
      nix-flatpak,
      nix-minecraft,
      nixcord,
      nixpkgs,
      nvf,
      stylix,
      nix-darwin,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        alienix = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/alienix/system
            ./modules/nixos/system
            ./modules/shared/system
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
                extraSpecialArgs = { inherit inputs; };
                users.dex.imports = [
                  ./hosts/alienix/home
                  ./modules/shared/home
                ];
              };
            }
          ];
        };

        recovery = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [ ./recovery/configuration.nix ];
        };
      };

      darwinConfigurations."darwin" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/darwin/system
          ./modules/shared/system
          stylix.darwinModules.stylix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              backupFileExtension = "backup";
              sharedModules = [
                nvf.homeManagerModules.default
                # nixcord.homeModules.nixcord
              ];
              extraSpecialArgs = { inherit inputs; };
              users.mac.imports = [
                ./hosts/darwin/home
                ./modules/shared/home
              ];
            };
          }
        ];
      };
    };
}
