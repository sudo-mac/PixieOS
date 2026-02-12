{ pkgs ? import <nixpkgs> { config.allowUnfree = true; }, }:
pkgs.mkShell {
  buildInputs = with pkgs; [ powershell ];

  shellHook = ''
    echo
    echo "Time to learn some PowerShell!"
  '';
}
