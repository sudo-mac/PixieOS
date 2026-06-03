{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    hyprland.url = "github:hyprwm/Hyprland";
    iio-hyprland.url = "github:JeanSchoeller/iio-hyprland";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    rust-overlay.url = "github:oxalica/rust-overlay";
    stylix.url = "github:nix-community/stylix/pull/2337/head";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      firefox-addons,
      home-manager,
      homebrew-cask,
      homebrew-core,
      hyprland,
      nix-darwin,
      nix-flatpak,
      nix-homebrew,
      nix-minecraft,
      nixcord,
      nixpkgs,
      nvf,
      stylix,
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
          ./modules/darwin/system
          ./modules/shared/system
          stylix.darwinModules.stylix
          home-manager.darwinModules.home-manager
          nix-homebrew.darwinModules.nix-homebrew
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

            nix-homebrew = {
              enable = true;
              user = "mac";
              autoMigrate = true;

              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
              };
            };
          }
        ];
      };
    };
}
