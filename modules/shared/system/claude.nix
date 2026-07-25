{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    claude-code
    claude-monitor
    claude-mergetool
    claude-agent-acp
    claude-code-router
  ];
}
