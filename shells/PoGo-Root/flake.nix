{
  description = "SpooferDex Android Development Lab Shell";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      scripts = import ./scripts.nix {inherit pkgs;};
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [android-tools scrcpy usbmuxd] ++ scripts;

        inputsFrom = [];

        shellHook = ''
          alias exit="adb kill-server && exit"
          adb start-server &> /dev/null
          echo
          fastfetch --logo android
          echo
          echo "Android Rooting and PoGo Spoofing Environment is running!"
        '';
      };
    });
}
