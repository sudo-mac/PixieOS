{
  config,
  lib,
  ...
}:
with lib; {
  options = {alienix.system.asus.enable = mkEnableOption "Enable ASUS plugins";};

  config = mkIf config.alienix.system.asus.enable {
    services = {
      asusd = {
        enable = true;
      };

      # Off. supergfxd switches a laptop between its integrated and discrete
      # GPUs, and this machine has no integrated one to switch to -- the Ryzen 7
      # 7435HS ships without a Radeon iGPU, so the 3050 is the only [0300]
      # device on the bus.
      #
      # It could not find the pair it exists to manage and said so on every
      # call:
      #
      #   supergfxd: [WARN ] DiscreetGpu::new: no devices??
      #   supergfxd: [WARN ] set_runtime_pm: Did not have dGPU handle
      #   supergfxd: [ERROR] get_runtime_status: Could not find dGPU
      #
      # It still got as far as setting the GPU's runtime PM to Auto on the way
      # past, which is the one effect it had on this machine and not a wanted
      # one. nvidia.nix now pins that back to "on".
      supergfxd.enable = false;
    };
  };
}
