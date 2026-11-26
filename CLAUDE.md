# PixieOS (alienix + the Mac): Claude's instructions

This is Matthew's NixOS / nix-darwin config. He doesn't use it every day and forgets how things fit, so it has a plain-words wiki in his LifeVault:

**`~/LifeVault/10 - NixOS System/`**: `NixOS Home` (map), `How to` (commands), `Services & Ports`, `Keybindings`, `Hosts`, `Themes`, `Changelog`, and `Modules/<name>.md` (one per module). The LV dashboard's 🐧 NixOS tab (http://alienix:8090/nixos) reads it.

## The rule: every change updates the wiki, in the same session
Whenever you change anything in this folder:
1. Update the matching note in `Modules/` (what it does, file, its `alienix.` switch and whether it's on, ports, gotchas). New module → new note with the same layout (`**Kind:** System | Desktop | Games | Apps (home)` line first; the dashboard groups by it).
2. New or changed port or background service → the `## Services` table in `Services & Ports.md` (the dashboard reads its columns: Service | Port | URL | What it does | Module).
3. New keybinding → `Keybindings.md`. New alias or command worth remembering → `How to.md` (each `###` heading with one code block; the dashboard shows the first line of each).
4. Add one line at the **top** of `Changelog.md`: `- **Mon D, YYYY:** what changed, in plain words`. Say if it still needs `nh os switch`.
Write for someone who forgot everything: plain words, where the file is, how to undo it.

## Working here
- Matthew runs `nh os switch .` himself (it needs his password). Check a change with `nix eval` / `nh os build .` first.
- New files must be `git add`ed or the flake can't see them.
- Never put secrets in notes or the wiki (e.g. `rustdesk-secrets.nix`, keys, tokens).
- Commit or push only when he asks.
