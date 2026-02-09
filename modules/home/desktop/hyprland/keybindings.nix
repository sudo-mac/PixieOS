{config, ...}: {
  # Hyprland Keybinds Configuration
  wayland.windowManager.hyprland = {
    settings = {
      "$mainMod" = "Super";

      bind = [
        # # Window/Session Actions
        "$mainMod, Q, killactive" # close focused window
        "$mainMod, T, togglefloating" # toggle the window between focus and float
        "$mainMod, J, togglesplit" # split the window
        "$mainMod, G, togglegroup" # toggle the window between focus and group
        "Shift, F11, fullscreen" # toggle the window between focus and fullscreen
        "$mainMod, L, exec, swaylock" # launch lock screen
        "$mainMod, Escape, exit" # exit Hyprland
        # "Ctrl+Alt, W, exec, killall waybar || waybar"   # toggle waybar without reloading
        # Screenshot Shortcuts
        "$mainMod, v, exec, sh -c 'grim -g \"$(slurp)\"'"

        # Application Shortcuts
        "$mainMod, W, exec, kitty" # launch terminal emulator
        "$mainMod, D, exec, discord" # launch discord
        "$mainMod, E, exec, kitty yazi" # launch file manager
        "$mainMod, C, exec, kitty nvim" # launch text editor
        "$mainMod, R, exec, kitty nix develop /etc/nixos/shells/PoGo-Root" # launch
        "$mainMod, B, exec, librewolf" # launch web browser
        "$mainMod, A, exec, rofi -show drun -show-icons" # launch application launcher

        # Move between grouped windows
        "$mainMod CTRL , H, changegroupactive, b"
        "$mainMod CTRL , L, changegroupactive, f"

        # Move/Change window focus
        "$mainMod, Left, movefocus, l"
        "$mainMod, Right, movefocus, r"
        "$mainMod, Up, movefocus, u"
        "$mainMod, Down, movefocus, d"
        "Alt, Tab, movefocus, d"

        # Switch workspaces
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Switch workspaces to a relative workspace
        "$mainMod+Ctrl, Right, workspace, r+1"
        "$mainMod+Ctrl, Left, workspace, r-1"

        # Move to the first empty workspace
        "$mainMod+Ctrl, Down, workspace, empty"

        # Scroll through existing workspaces
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"

        # Move focused window to a workspace silently
        "$mainMod+Alt, 1, movetoworkspacesilent, 1"
        "$mainMod+Alt, 2, movetoworkspacesilent, 2"
        "$mainMod+Alt, 3, movetoworkspacesilent, 3"
        "$mainMod+Alt, 4, movetoworkspacesilent, 4"
        "$mainMod+Alt, 5, movetoworkspacesilent, 5"
        "$mainMod+Alt, 6, movetoworkspacesilent, 6"
        "$mainMod+Alt, 7, movetoworkspacesilent, 7"
        "$mainMod+Alt, 8, movetoworkspacesilent, 8"
        "$mainMod+Alt, 9, movetoworkspacesilent, 9"
        "$mainMod+Alt, 0, movetoworkspacesilent, 10"

        # Move/Switch to special workspace (scratchpad)
        "$mainMod+Alt, S, movetoworkspacesilent, special"
        "$mainMod, S, togglespecialworkspace,"
      ];

      binde = [
        # Resize Windows
        "$mainMod+Shift, Right, resizeactive, 30 0"
        "$mainMod+Shift, Left, resizeactive, -30 0"
        "$mainMod+Shift, Up, resizeactive, 0 -30 0"
        "$mainMod+Shift, Down, resizeactive, 0 30"
      ];

      bindm = [
        # Move/Resize focused window
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
        "$mainMod, Z, movewindow"
        "$mainMod, X, resizewindow"
      ];
    };
  };
}
