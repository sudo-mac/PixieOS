{ inputs, pkgs, lib, ... }: {

  # System Configuration
  hardware = {
    graphics.enable = true;
    graphics.enable32Bit = true;
    enableRedistributableFirmware = true;
  };

  # No videoDrivers here. This file used to add [ "radeon" "amdgpu" ] and
  # gaming.nix used to add [ "radeon" "amdgpu" "nvidia" ], and the three
  # declarations merged into one list naming two drivers for hardware this
  # machine does not have. nvidia.nix owns the list now; a host with an AMD
  # card should say so from its own module rather than from here, where it
  # applied to every NixOS host unconditionally.
}
