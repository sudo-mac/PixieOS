# Every theme the config knows about. Adding one is a single line here plus its
# own directory -- nothing outside modules/themes/ needs to change.
{ pkgs }:
let
  mkTheme = import ./mkTheme.nix { inherit pkgs; };
in
{
  cybergirl = mkTheme (import ./cybergirl { inherit pkgs; });
  kimberly = mkTheme (import ./kimberly { inherit pkgs; });
}
