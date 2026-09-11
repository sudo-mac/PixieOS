{ pkgs, ... }:
{
  # Declared here rather than in environment.systemPackages so stylix's chromium
  # target can reach it -- the target works through home-manager's
  # programs.chromium policies, which a bare package install never creates.
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
  };
}
