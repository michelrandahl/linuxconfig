# enable unfree pakcages in nix..
# symlink this file to users home dir:
# $ ln -s /etc/nixos/nixpkgs-config.nix ~/.config/nixpkgs/config.nix
{ pkgs }:

{
  allowUnfree = true;
}
