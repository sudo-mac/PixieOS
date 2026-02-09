{ config, pkgs, ... }:

{
  wsl.enable = true;
  wsl.defaultUser = "windrone"

    networking.hostname = "windrone"
  }
