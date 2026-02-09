{pkgs, ...}: {
  users.users.dex = {
    isNormalUser = true;
    description = "dexalyth";
    extraGroups = ["networkmanager" "wheel" "adbusers" "openrazer" "usbmuxd" "dialout" "minecraft"];
    shell = pkgs.zsh;
  };
}
