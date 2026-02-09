{ pkgs }:

[

  (pkgs.writeShellScriptBin "McLaren-crDroid7-A11" ''
    cd ~/Android/McLaren/crDroid7-A11/
    bash install.sh
    cd 
  '')

  (pkgs.writeShellScriptBin "McLaren-crDroid8-A12" ''
    cd ~/Android/McLaren/crDroid8-A12/
    bash install.sh
    cd 
  '')

  (pkgs.writeShellScriptBin "McLaren-crDroid9-A13" ''
    cd ~/Android/McLaren/crDroid9-A13/
    bash install.sh
    cd 
  '')

  (pkgs.writeShellScriptBin "McLaren-crDroid10-A14" ''
    cd ~/Android/McLaren/crDroid10-A14/
    bash install.sh
    cd 
  '')

  (pkgs.writeShellScriptBin "OnePlus6T-crDroid7-A11" ''
    cd ~/Android/OnePlus6T/crDroid7-A11
    bash install.sh
    cd 
  '')

  (pkgs.writeShellScriptBin "OnePlus6T-crDroid8-A12" ''
    cd ~/Android/OnePlus6T/crDroid7-A11
    bash install.sh
    cd 
  '')

  (pkgs.writeShellScriptBin "OnePlus6T-crDroid9-A13" ''
    cd ~/Android/OnePlus6T/crDroid9-A13
    bash install.sh
    cd 
  '')

  (pkgs.writeShellScriptBin "OnePlus6T-crDroid10-A14" ''
    cd ~/Android/OnePlus6T/crDroid10-A14
    bash install.sh=
    cd 
  '')

  (pkgs.writeShellScriptBin "OnePlus7T-crDroid9-A13" ''
    cd ~/Android/OnePlus7T/crDroid9-A13
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
    cd
  '')

  (pkgs.writeShellScriptBin "OnePlus9-crDroid9-A13" ''
    cd ~/Android/OnePlus9/crDroid9-A13
    bash install.sh
    cd 
  '')

  (pkgs.writeShellScriptBin "OnePlus9-crDroid10-A14" ''
    cd ~/Android/OnePlus9/crDroid10-A14
    bash install.sh
    cd 
  '')

  (pkgs.writeShellScriptBin "Pixel4-OEM-A13" ''
    cd ~/Android/Pixel4/OEM-A13-Magisk
    bash install.sh
    cd
  '')

  (pkgs.writeShellScriptBin "Pixel4-DerpFest-A13" ''
    cd ~/Android/Pixel4/DerpFest-A13
    fastboot -w
    fastboot flash boot boot.img --slot all
    echo && read -p "On the device, Select Recovery Using the volume buttons, then, while in recovery, tap Factory Reset, then Format data / factory reset, and continue. 

    Again, select Apply Update, then Apply from ADB to put the device in ADB sideload mode.

    Press Enter to Flash ROM."
    adb sideload ROM.zip
    echo && read -p "Now once again, on the device, select Apply Update, then Apply from ADB to begin sideload.

    Press Enter to Flash Gapps."
    adb sideload Gapps.zip
    echo && read -p "One more time, on the device, select Apply Update, then Apply from ADB to begin sideload.

    Press Enter to Flash Magisk."
    adb sideload ~/Android/Apps/Magisk.apk
    cd
  '')


  (pkgs.writeShellScriptBin "Pixel5-crDroid9-A13" ''
    cd ~/Android/Pixel5/crDroid9-A13
    bash install.sh
    cd 
  '')

  (pkgs.writeShellScriptBin "Pixel5-crDroid10-A14" ''
    cd ~/Android/Pixel5/crDroid10-A14
    sudo bash install.sh
    cd 
  '')

  (pkgs.writeShellScriptBin "Pixel5-GrapheneOS-A14" ''
    cd ~/Android/Pixel5/GrapheneOS-A14
    bash install.sh
    cd 
  '')

  (pkgs.writeShellScriptBin "Pixel5-OEM-A11" ''
    cd ~/Android/Pixel5/OEM-A11-Latest
    bash install.sh
    cd 
  '')

  (pkgs.writeShellScriptBin "Pixel5-OEM-A12" ''
    cd ~/Android/Pixel5/OEM-A12-Latest
    bash install.sh
    cd 
  '')

  (pkgs.writeShellScriptBin "Pixel5-OEM-A13" ''
    cd ~/Android/Pixel5/OEM-A13-Latest
    bash install.sh
    cd 
  '')

  (pkgs.writeShellScriptBin "Pixel5-OEM-A14" ''
    cd ~/Android/Pixel5/OEM-A14-Latest
    bash install.sh
    cd 
  '')

  (pkgs.writeShellScriptBin "Pixel6-crDroid10-A14" ''
    cd ~/Android/Pixel6/crDroid10-A14
    sudo bash install.sh
    cd 
  '')

  (pkgs.writeShellScriptBin "Pixel6-OEM-A13" ''
    #!/bin/bash

    cd ~/Android/Pixel6/OEM-A13-Magisk 
    sudo bash install.sh
    cd 
  '')

  (pkgs.writeShellScriptBin "Pixel6-OEM-A15" ''
    cd ~/Android/Pixel6/OEM-A15-Magisk
    bash install.sh
    cd 
  '')

  (pkgs.writeShellScriptBin "Pixel6Pro-OEM-A13" ''
    cd ~/Android/Pixel6Pro/OEM-A13-Magisk
    bash install.sh
    cd 
  '')

  (pkgs.writeShellScriptBin "Pixel6a-DerpFest-A14" ''
    cd ~/Android/Pixel6a/DerpFest-A14
    bash install.sh
    cd 
  '')

  (pkgs.writeShellScriptBin "Pixel6a-OEM-A13" ''
    cd ~/Android/Pixel6a/OEM-A13-Magisk
    bash install.sh
    cd 
  '')

  (pkgs.writeShellScriptBin "Pixel7a-crDroid9-A13" ''
    cd ~/Android/Pixel7a/crDroid9-A13
    bash install.sh
    cd 
  '')

  (pkgs.writeShellScriptBin "Pixel7a-crDroid10-A14" ''
    cd ~/Android/Pixel7a/crDroid10-A14
    bash install.sh
    cd 
  '')

  (pkgs.writeShellScriptBin "Pixel7a-OEM-A13" ''
    cd ~/Android/Pixel7a/OEM-A13-Latest
    bash install.sh
    cd 
  '')

  (pkgs.writeShellScriptBin "Pixel7a-OEM-A14" ''
    cd ~/Android/Pixel7a/OEM-A14-Latest
    bash install.sh
    cd 
  '')

  (pkgs.writeShellScriptBin "PokeApps" ''
      cd ~/Android/Apps

      # sudo bash Scripts/Pixel6-Dirinstall.sh;
    
      set -e
    
      # CHOICE OF POKEMON GO SPOOFING PACKAGE
      while true; do
    
          echo && read -p "PGSharp [1] or Pokemod [2]?: " pokechoice
        
          case $pokechoice in
              [1]* ) echo && echo "Installing PGSharp spoofers package...";
      	   for device in $(adb devices | grep device$ | cut -f1); do
                    adb -s "$device" install PGSharp.apk >> /dev/null;
      	     adb -s "$device" push lawnchair-backups/PGsharp.lawnchairbackup /sdcard/ >> /dev/null;
            	   done
      	   break;;
              [2]* ) echo && echo "Installing Pokemod spoofers package";
      	   for device in $(adb devices | grep device$ | cut -f1); do
                    adb -s "$device" install Pokemod.apk >> /dev/null;
      	     adb -s "$device" push lawnchair-backups/Pokemod.lawnchairbackup /sdcard/ >> /dev/null;
                  done
      	   break;;
              * ) echo "Invalid Response!";;
          esac
    
      done
    
    
      for device in $(adb devices | grep device$ | cut -f1); do
    
      # FULL LOAD OF COMPATIBLE POKEMON GO APPS
        adb -s "$device" install AdAway.apk >> /dev/null
        adb -s "$device" install AirDroid-RemoteSupport.apk >> /dev/null
        adb -s "$device" install APKcombo.apk >> /dev/null
        adb -s "$device" install DataHub.apk >> /dev/null
        adb -s "$device" install Droid-ify.apk >> /dev/null
        adb -s "$device" install GPSJoystick.apk >> /dev/null
        adb -s "$device" install HideMockLocation.apk >> /dev/null
        adb -s "$device" install iPoGo.apk >> /dev/null
        adb -s "$device" install Lawnchair.apk >> /dev/null
        adb -s "$device" install PGtools.apk >> /dev/null
        adb -s "$device" install PolygonX.apk >> /dev/null
        adb -s "$device" install RemoteSupport-Plugin.apk >> /dev/null
        adb -s "$device" install RootChecker.apk >> /dev/null
        adb -s "$device" install RootExplorer.apk >> /dev/null
        adb -s "$device" install Shungo.apk >> /dev/null
        adb -s "$device" push PlayIntegrityFix.zip /sdcard/ >> /dev/null
        adb -s "$device" push LSPosed.zip /sdcard/ >> /dev/null
        adb -s "$device" push ZygiskNext.zip /sdcard/ >> /dev/null
        adb -s "$device" push Shamiko.zip /sdcard/ >> /dev/null
        adb -s "$device" push TrickyStore.zip /sdcard/ >> /dev/null
        adb -s "$device" push TrickyAddon.zip /sdcard/ >> /dev/null
        adb -s "$device" shell "su -c 'magisk --install-module /sdcard/PlayIntegrityFix.zip'" >> /dev/null
        adb -s "$device" shell "su -c 'magisk --install-module /sdcard/LSPosed.zip'" >> /dev/null
        adb -s "$device" shell "su -c 'magisk --install-module /sdcard/ZygiskNext.zip'" >> /dev/null
        adb -s "$device" shell "su -c 'magisk --install-module /sdcard/Shamiko.zip'" >> /dev/null
        adb -s "$device" shell "su -c 'magisk --install-module /sdcard/TrickyStore.zip'" >> /dev/null
        adb -s "$device" shell "su -c 'magisk --install-module /sdcard/TrickyAddon.zip'" >> /dev/null
        adb -s "$device" shell "su -c 'rm -rf /sdcard/PlayIntegrityFix.zip'" >> /dev/null
        adb -s "$device" shell "su -c 'rm -rf /sdcard/LSPosed.zip'" >> /dev/null
        adb -s "$device" shell "su -c 'rm -rf /sdcard/ZygiskNext.zip'" >> /dev/null
        adb -s "$device" shell "su -c 'rm -rf /sdcard/Shamiko.zip'" >> /dev/null
        adb -s "$device" shell "su -c 'rm -rf /sdcard/TrickyStore.zip'" >> /dev/null
        adb -s "$device" shell "su -c 'rm -rf /sdcard/TrickyAddon.zip'" >> /dev/null
        # adb -s "$device" reboot
    
      done

      # RANDOM COMPUTER GENERATED BOOTANIMATION
      while true; do
    
          echo && read -p "Would you like a custom bootanimation chosen by random? (Y/n): " yn
    
          case $yn in
              [yY]* ) echo && echo "But... which one will it be...?";
                  commands=(
                      "adb -s '$device' push Bootanimations/Dratini.zip /sdcard/bootanimation.zip >> /dev/null"
                      "adb -s '$device' push Bootanimations/Charizard.zip /sdcard/bootanimation.zip >> /dev/null"
                      "adb -s '$device' push Bootanimations/Pikachu.zip /sdcard/bootanimation.zip >> /dev/null"
                      "adb -s '$device' push Bootanimations/Horsea.zip /sdcard/bootanimation.zip >> /dev/null");
                  index=$((RANDOM % ${#commands[@]}));
                  eval ${commands[$index]};
                  sleep 1;
                  echo && echo "Random Bootanimation Downloaded! (:"; break;;
              [nN]* ) echo "Skipping Random Bootanimation... ):"; break;;
              * ) echo "Invalid Response!";;
          esac
    
      done
      echo && echo "Press enter to exit." && read

      cd 
    '')

    (pkgs.writeShellScriptBin "pixel-bootloader-unlock" ''
      #!/bin/bash

      for device in $(adb devices | grep device$ | cut -f1); do
      sudo adb -s "$device" reboot bootloader
      sudo fastboot -s "$device" flashing unlock &
      done
  '')

]















<<<<<<< HEAD
=======


>>>>>>> refs/remotes/origin/main










































































































































