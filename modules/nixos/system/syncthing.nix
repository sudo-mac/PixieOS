{
  config,
  lib,
  ...
}:
with lib; {
  options = { alienix.system.syncthing.enable = mkEnableOption "Enable Syncthing"; };

  # Keeps OurVault (the Obsidian vault shared with Ashley) in sync between
  # this laptop and her computer. Each side has a full copy; changes sync
  # whenever both are online, over the LAN or through Syncthing's relays.
  config = mkIf config.alienix.system.syncthing.enable {
    services.syncthing = {
      enable = true;
      user = "dex";
      group = "users";
      dataDir = "/home/dex";
      configDir = "/home/dex/.config/syncthing";

      # 22000/tcp+udp for sync, 21027/udp for LAN discovery.
      openDefaultPorts = true;

      # Ashley's device gets added (and the folder shared with it) from the
      # web UI at http://127.0.0.1:8384, so don't wipe those on rebuild.
      overrideDevices = false;
      overrideFolders = false;

      settings = {
        options.urAccepted = -1; # no usage reporting
        folders.ourvault = {
          label = "OurVault";
          path = "/home/dex/OurVault";
          # Keep old versions of changed/deleted notes for 30 days, in
          # OurVault/.stversions, in case one of us overwrites the other.
          versioning = {
            type = "staggered";
            params.maxAge = toString (30 * 24 * 60 * 60);
          };
        };
      };
    };
  };
}
