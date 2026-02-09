{ pkgs ? import <nixpkgs> { config.allowUnfree = true; }, }:
pkgs.mkShell {
  buildInputs = with pkgs; [ nodejs ];

  shellHook = ''
    echo
    echo "Time to learn some JavaScript!"
  '';
}
