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
        mkrecovery = "nom build .#nixosConfigurations.recovery.config.system.build.isoImage";

        mkdir = "mkdir -p";
      }
      // lib.optionalAttrs pkgs.stdenv.isDarwin {
        switch = "nh darwin switch .#darwin";
        build = "nh darwin build .#darwin";
        rsync-flake = "rsync -av alienix:/etc/nixos /etc/nixos";

        ls = "ls --color=always";
        l = "ls -l --color=always";
        ll = "ls -la --color=always";
        tree = "tree -C";
      };
  };
}
