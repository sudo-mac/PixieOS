{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; {
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
    ./server-mods.nix
  ];

  options = {alienix.system.gaming.minecraft.servers.fabric-1_21_1.enable = mkEnableOption "Enable Minecraft Server";};

  config = mkIf config.alienix.system.gaming.minecraft.servers.fabric-1_21_1.enable {
    nixpkgs.overlays = [inputs.nix-minecraft.overlay];

    environment.systemPackages = with pkgs; [
      minecraft-server
    ];

    services.minecraft-servers = {
      enable = true;
      eula = true;
      servers.fabric = {
        enable = true;
        package = pkgs.fabricServers.fabric-1_21_1.override {
          loaderVersion = "0.18.4";
        };

        serverProperties = {
          motd = "Learn Lua in Minecraft!";
          gamemode = 1;
          difficulty = 0;
          openFirewall = true;
          white-list = false;
          online-mode = false;
          allow-cheats = true;
        };
      };
    };
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [25565];
    };
  };
}
