{ pkgs ? import <nixpkgs> { config.allowUnfree = true; }, }:
pkgs.mkShell {
  buildInputs = with pkgs; [ python3 ];

  shellHook = ''
    echo
    echo "Time to learn some Python!"
  '';
}
