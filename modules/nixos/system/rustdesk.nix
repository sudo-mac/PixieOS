{ pkgs, ... }:

{
  environment.systemPackages = [
    # nixpkgs builds with the "linux-pkg-config" feature, so libsodium-sys
    # needs libsodium visible to pkg-config, but it's missing from buildInputs.
    (pkgs.rustdesk-flutter.overrideAttrs (prev: {
      buildInputs = prev.buildInputs ++ [ pkgs.libsodium ];
    }))
  ];

  services.rustdesk-server = {
    enable = true;
    openFirewall = true;
  };

}
