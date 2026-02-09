{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {alienix.system.ssh.enable = mkEnableOption "Enables SSH";};

  config = mkIf config.alienix.system.ssh.enable {
    services.openssh = {
      enable = true;
      ports = [44906];
      settings = {
        PasswordAuthentication = false;
        UseDns = true;
        X11Forwarding = true;
        PermitRootLogin = "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
      };
    };

    # Start Enable and Start SSH Agent On Startup
    programs.ssh = {
      startAgent = true;
      extraConfig = ''
        Host github.com
          User git
          IdentityFile ~/.ssh/homelab
          IdentitiesOnly yes

        Host gitlab.com
          User git
          IdentityFile ~/.ssh/homelab
          IdentitiesOnly yes

        Host alienix
          User dex
          Port 44906
          IdentityFile ~/.ssh/nixathon
          IdentitiesOnly yes

        Host drone
          User dex
          Port 44906
          IdentityFile ~/.ssh/nixathon
          IdentitiesOnly yes
      '';
    };
  };
}
