{ inputs, config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./options.nix
  ];

  # Set the hostname.
  networking.hostName = "drone";
}
