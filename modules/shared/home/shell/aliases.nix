{
  pkgs,
  lib,
  ...
}: {
  programs = {
    zsh.shellAliases =
      {
        pxie = "cd /etc/nixos/ && git pull";
        update = "nix flake update --flake .";
        switch = "nh os switch .";
        build = "nh os build .";
        cleanup = "nix-collect-garbage --delete-older-than 15d";
        cleanup-full = "sudo nix-collect-garbage --delete-older-than 15d";
        mkrecovery = "nix build .#nixosConfigurations.recovery.config.system.build.isoImage";

        mkdir = "mkdir -p";
      }
      // lib.optionalAttrs pkgs.stdenv.isDarwin {
        rsync-flake = "rsync -av alienix:/etc/nixos /etc/nixos";
      };
  };
}
