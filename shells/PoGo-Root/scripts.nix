{ pkgs }: [
  (pkgs.writeShellScriptBin "McLaren-crDroid7-A11" ''
    cd McLaren/crDroid7-A11/
    bash install.sh
    cd
  '')

  (pkgs.writeShellScriptBin "McLaren-crDroid8-A12" ''
    cd McLaren/crDroid8-A12/
    bash install.sh
    cd
  '')

  (pkgs.writeShellScriptBin "McLaren-crDroid9-A13" ''
    cd McLaren/crDroid9-A13/
    bash install.sh
    cd
  '')

  (pkgs.writeShellScriptBin "McLaren-crDroid10-A14" ''
    cd McLaren/crDroid10-A14/
    bash install.sh
    cd
  '')

  (pkgs.writeShellScriptBin "OnePlus6T-crDroid9-A13" ''
    cd OnePlus6T/crDroid9-A13
    bash install.sh
    cd
  '')

  (pkgs.writeShellScriptBin "OnePlus7T-crDroid9-A13" ''
    cd OnePlus7T/crDroid9-A13
    fastboot flash dtbo dtbo.img
    fastboot flash vbmeta vbmeta.img
    fastboot flash recovery_a recovery.img
    fastboot flash recovery_b recovery.img
    fastboot reboot recovery
    echo && read -p "On the device, tap Factory Reset, then Format data / factory reset, and continue.

    Then, select Apply Update, then Apply from ADB to put the device in ADB sideload mode.

    Press Enter to Flash ROM."
    adb sideload ROM.zip
    echo && read -p "Again, on the device, select Apply Update, then Apply from ADB to begin sideload.

    Press Enter to Flash Gapps."
    adb sideload Gapps.zip
    echo && read -p "One more time, on the device, select Apply Update, then Apply from ADB to begin sideload.

    Press Enter to Flash Magisk."
    adb sideload ~/Android/Apps/Magisk.apk
    cd ../../
  '')

  (pkgs.writeShellScriptBin "OnePlus9-crDroid9-A13" ''
    cd OnePlus9/crDroid9-A13
    bash install.sh
    cd
  '')

  (pkgs.writeShellScriptBin "Pixel4-OEM-A13" ''
    cd Pixel4/OEM-A13-Magisk
    bash install.sh
    cd ../../
  '')

  (pkgs.writeShellScriptBin "Pixel4-DerpFest-A13" ''
    cd Pixel4/DerpFest-A13
    fastboot -w
    fastboot flash boot boot.img --slot all

    adb wait-for-sideload sideload ROM.zip

    adb wait-for-sideload sideload Gapps.zip

    adb wait-for-sideload sideload ~/Android/Apps/Magisk.apk
    cd ../../
  '')

  (pkgs.writeShellScriptBin "Pixel5-crDroid9-A13" ''
    cd Pixel5/crDroid9-A13
    bash install.sh
    cd
  '')

  (pkgs.writeShellScriptBin "Pixel5-OEM-A13" ''
    cd Pixel5/OEM-A13-Latest
    bash install.sh
    cd
  '')

  (pkgs.writeShellScriptBin "Pixel6-OEM-A13" ''
    cd Pixel6/OEM-A13-Magisk
    bash install.sh
    cd ../../
  '')

  (pkgs.writeShellScriptBin "Pixel6Pro-OEM-A13" ''
    cd Pixel6Pro/OEM-A13-Magisk
    bash install.sh
  '')

  (pkgs.writeShellScriptBin "Pixel6a-OEM-A13" ''
    bash /Apps/install.sh
  '')

  (pkgs.writeShellScriptBin "Pixel7a-crDroid9-A13" ''
    cd Pixel7a/crDroid9-A13
    bash install.sh
    cd
  '')

  (pkgs.writeShellScriptBin "Pixel7a-OEM-A13" ''
    cd Pixel7a/OEM-A13-Latest
    bash install.sh
    cd
  '')

  (pkgs.writeShellScriptBin "PokeApps" '' 
    cd Apps/
    bash installapps.sh
    cd ..
  '')

  (pkgs.writeShellScriptBin "scrcpy-all" ''
    #!/bin/bash

    for device in $(adb devices | grep device$ | cut -f1); do
    scrcpy -s "$device" &
    done
  '')

  (pkgs.writeShellScriptBin "pixel-bootloader-unlock" ''
    #!/bin/bash

    for device in $(adb devices | grep device$ | cut -f1); do
    adb -s "$device" reboot bootloader
    fastboot -s "$device" flashing unlock &
    done
  '')
]
