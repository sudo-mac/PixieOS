{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    rustdesk-flutter
  ];

  services.rustdesk-server = {
    enable = true;
    openFirewall = true;
  };

}
