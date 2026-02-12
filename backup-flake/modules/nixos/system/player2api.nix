{ stdenv, fetchurl, python3, git, nodejs, lib }:

stdenv.mkDerivation {
  pname = "p2installer";
  version = "unstable-2026-01-01";

  # Download the installer script
  src = fetchurl {
    url = "https://raw.githubusercontent.com/OptimiDEV/P2Installer/main/main.py";
    sha256 = "1g4qrbi3x887hacwznhyhhvx0gf5an272428xym6j03lzpsanx68";
  };

  # This is a single file, so no unpacking
  dontUnpack = true;

  # Dependencies that the script would normally try to install
  buildInputs = [ python3 git nodejs ];

  # Install the script in $out/bin
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/p2installer
    chmod +x $out/bin/p2installer
    # Fix the shebang so it points to the Nix store python
    patchShebangs $out/bin/p2installer
  '';

  # Metadata
  meta = with lib; {
    description = "Player2 installer script wrapped for NixOS";
    homepage = "https://github.com/OptimiDEV/P2Installer";
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}

