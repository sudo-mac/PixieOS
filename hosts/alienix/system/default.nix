{
  imports = [
    ./hardware-configuration.nix
    ./options.nix
    ./ssd.nix
  ];

  # Set the hostname.
  networking.hostName = "alienix"; # Define your hostname.
}
