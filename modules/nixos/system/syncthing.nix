{
  config,
  lib,
  ...
}:
with lib;
{
  options = {
    alienix.system.syncthing.enable = mkEnableOption "Enable Syncthing";
  };

  # Keeps OurVault (the Obsidian vault shared with Ashley) and AshleyVault
  # (her own private vault) in sync between this laptop and her computer. Each side has a full copy; changes sync
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

      # Extra devices/folders added in the web UI (http://127.0.0.1:8384) are
      # kept on rebuild.
      overrideDevices = false;
      overrideFolders = false;

      settings = {
        options.urAccepted = -1; # no usage reporting

        # Ashley's PC (Windows, DESKTOP-MJGJAQF). It has to be declared here: on
        # every switch NixOS re-applies each folder below with exactly the
        # devices listed in it, so a share made only in the web UI got dropped
        # (that's how OurVault silently stopped syncing to her, Nov 2026).
        devices.Ashley.id = "BWTP2DD-X2YINMW-XLHQTG6-VUXK5WF-BNCQUJQ-Y3KBCYP-26AQAL3-5GSJDAC";
        folders.ourvault = {
          label = "OurVault";
          path = "/home/dex/OurVault";
          devices = [ "Ashley" ];
          # Keep old versions of changed/deleted notes for 30 days, in
          # OurVault/.stversions, in case one of us overwrites the other.
          versioning = {
            type = "staggered";
            params.maxAge = toString (30 * 24 * 60 * 60);
          };
        };
        # Ashley's own vault, shared only with her PC.
        # Her copy should be an empty Documents\AshleyVault folder.
        folders.ashleyvault = {
          label = "AshleyVault";
          path = "/home/dex/AshleyVault";
          devices = [ "Ashley" ];
          versioning = {
            type = "staggered";
            params.maxAge = toString (30 * 24 * 60 * 60);
          };
        };
      };
    };
  };
}
