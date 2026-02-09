{ pkgs ? import <nixpkgs> { config.allowUnfree = true; }, }:
let scripts = import ./scripts.nix { inherit pkgs; };
in pkgs.mkShell {
  buildInputs = with pkgs; [ android-tools scrcpy usbmuxd ] ++ scripts;

  inputsFrom = [ ];

  shellHook = ''
    alias exit="adb kill-server && exit"
    adb start-server &> /dev/null
    echo
    echo "Android Rooting and PoGo Spoofing Environment is running!"
  '';
}
