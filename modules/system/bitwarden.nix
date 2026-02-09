{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    bitwarden-cli
    bitwarden-desktop
    bitwarden-menu
  ];
}
