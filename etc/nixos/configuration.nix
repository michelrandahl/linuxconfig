# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, stdenv, ... }:

let
  fix_lenovo_trackpoint = ''
    xinput set-prop "TPPS/2 IBM TrackPoint" "Device Accel Constant Deceleration" 0.55 &
    xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation" 1 &
    xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Button" 2 &
    xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Timeout" 200 &
    # disable stupid unix middle mouse click paste feature
    xinput set-button-map 10 1 0 3 &
    # to find id of mouse do:
    # $ xinput list | grep 'id='<Paste>
  '';
  essentialPackages = with pkgs; [
    git
    wget
    networkmanager
    gnome3.gnome_terminal
    gnome3.dconf
    openssh
    openvpn
    xterm
    htop
    acpi
    sysstat
    nix-repl
    nix-prefetch-git
    gcc
    baobab
  ];
  visualPackages = with pkgs; [
    feh
    i3blocks
    i3lock
    xorg.xbacklight
  ];
  audioPackages = with pkgs; [
    pavucontrol
  ];
  editorPackages = with pkgs; [
    neovim
    emacs
    xclip
    ctags
  ];
  hsPackages = with pkgs.haskellPackages; [
    cabal2nix
    cabal-install
    ghc
    idris
  ];
  developerPackages = with pkgs; [
    leiningen
    sbt
    lua
    jq
    mono
    fsharp
    elixir
    elmPackages.elm
  ];
  miscPackages = with pkgs; [
    libreoffice
    evince
  ];
  unfree = import "/nix/var/nix/profiles/per-user/root/channels/nixos" {
    config = {
      allowUnfree = true;
    };
  };
  unstable_unfree = import "/nix/var/nix/profiles/per-user/root/channels/nixos-unstable" {
    config = {
      allowUnfree = true;
    };
  };
  unfreePackages = with pkgs; [
    unstable_unfree.google-chrome
    unfree.spotify
  ];
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  hardware = {
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };
    bluetooth.enable = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "michelnixos";
    # get hostId with following command
    # $ cksum /etc/machine-id | while read c rest; do printf "%x" $c; done
    hostId = "DE4B8678";
    enableIPv6 = true;
    networkmanager.enable = true;
  };

  environment = {
    variables = {
      EDITOR = "nvim";
    };
    # enableBashCompletion = true;
    extraInit = fix_lenovo_trackpoint;
  };
  programs = {
    bash.enableCompletion = true;
    java.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  nixpkgs.config = {
    allowUnfree = true;
  };
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    essentialPackages ++
    visualPackages ++
    audioPackages ++
    editorPackages ++
    hsPackages ++
    developerPackages ++
    miscPackages ++
    unfreePackages;

  fonts = {
    enableCoreFonts = true;
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      source-code-pro
    ];
  };

  services = {
    openssh.enable = true;

    printing.enable = true;

    acpid.enable = true;

    compton = {
      enable = true;
      activeOpacity = "0.93";
      inactiveOpacity = "0.75";
    };

    xserver = {
      autorun = true;
      enable = true;
      layout = "us";
      displayManager = {
        lightdm.enable = true;
	# sessionCommands = fix_lenovo_trackpoint;
      };
      windowManager.i3.enable = true;
      videoDrivers = ["intel" ];

      synaptics = {
        enable = true;
        buttonsMap = [ 10 1 0 3 ];
        fingersMap = [ 1 2 3 ];
        palmDetect = false;
        tapButtons = true;
        twoFingerScroll = true;
        vertEdgeScroll = false;
      };
    };
  };

  security.sudo = {
    enable = true;
    configFile = ''
      Defaults env_reset
      root ALL = (ALL:ALL) ALL
      %wheel ALL = (ALL) SETENV: NOPASSWD: ALL
    '';
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    extraUsers.michel = {
      home = "/home/michel";
      isNormalUser = true;
      uid = 1000;
      extraGroups = [ "wheel" "networkmanager" "docker" "cassandra" ];
    };
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";
}
