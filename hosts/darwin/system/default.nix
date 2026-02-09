{ pkgs
, config
, lib
, ...
}: {
  imports = [
    ./ssh.nix
    ./stylix.nix
  ];

  environment.systemPackages = with pkgs; [ discord sshfs notion-app ];

  nixpkgs.config = {
    hostPlatform = "aarch64-darwin";
    allowUnfree = true;
    allowUnsupportedSystem = false;
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  homebrew = {
    enable = true;
    casks = [ "rustdesk" "qflipper" "firefox" "bambu-studio" "vscodium" "macfuse" ];
  };

  users.users.matthew = {
    home = "/Users/matthew";
  };

  # services.yabai = {
  #   enable = true;
  #   config = {
  #      focus_follows_mouse = "off";
  #      mouse_follows_focus = "off";
  #      window_placement    = "second_child";
  #      window_opacity      = "off";
  #      top_padding         = 36;
  #      bottom_padding      = 10;
  #      left_padding        = 10;
  #      right_padding       = 10;
  #      window_gap          = 10;
  #   };
  # };

  system = {
    primaryUser = "matthew";
    configurationRevision = null;
    stateVersion = 6;
  };
}
