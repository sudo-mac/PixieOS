{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  options = {alienix.system.ssh.enable = mkEnableOption "Enables SSH";};

  config = mkIf config.alienix.system.ssh.enable {
    services.openssh =
      {
        enable = true;
      }
      // lib.optionalAttrs pkgs.stdenv.isLinux {
        ports = [44906];
        settings = {
          PasswordAuthentication = false;
          UseDns = true;
          X11Forwarding = true;
          PermitRootLogin = "prohibit-password";
        };
      };

    # Start Enable and Start SSH Agent On Startup
    programs.ssh =
      {
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

          Host sphero
            User rvr
            IdentityFile ~/.ssh/rvr
            IdentitiesOnly yes
        '';
      }
      // lib.optionalAttrs pkgs.stdenv.isLinux {
        startAgent = true;
      };
  };
}
