# enable unfree pakcages in nix..
# symlink this file to users home dir:
# $ ln -s /etc/nixos/nixpkgs-config.nix ~/.config/nixpkgs/config.nix
# clone git repository with latest nix packages:
# $ git clone https://github.com/nixos/nixpkgs ~/nixpkgs
# now unfree packages such as google-chrome and spotify can be installed:
# $ nix-env -f ~/nixpkgs/default.nix -iA spotify

{ pkgs }:

{
  allowUnfree = true;
}
