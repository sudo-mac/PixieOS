{ pkgs, ... }:
{
  imports = [
    ../../themes
    ./ssh.nix
    ./stylix.nix
    ./tmux.nix
    ./claude.nix
  ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    nh
    nix-output-monitor
    bat
    btop
    tree
    weathr
    lolcat
    blender
    openscad
    fastfetch
    onefetch
  ];
}
