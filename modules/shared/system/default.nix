{pkgs, ...}: {
  imports = [
    ./ssh.nix
    ./stylix.nix
  ];

  environment.systemPackages = with pkgs; [
    nh
    nix-output-monitor
    bat
    tree
    weathr
    lolcat
    fastfetch
    onefetch
  ];
}
