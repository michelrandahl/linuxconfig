# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  hardware.pulseaudio.enable = true;

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

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget
    neovim
    emacs
    networkmanager
    gnome3.gnome_terminal
    openssh
    xterm
    htop
    acpi
  ];

  services = {
    openssh.enable = true;

    printing.enable = true;

    acpid.enable = true;

    xserver = {
      autorun = true;
      enable = true;
      layout = "us";
      displayManager.lightdm.enable = true;
      windowManager.i3.enable = true;
      videoDrivers = ["intel" ];

      synaptics = {
        enable = true;
        buttonsMap = [ 1 2 3 ];
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

  nixpkgs.config = {
    allowUnfree = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    extraUsers.michel = {
      home = "/home/michel";
      isNormalUser = true;
      uid = 1000;
      extraGroups = [ "wheel" "networkmanager" "docker" "cassandra" ];
    };
    # defaultUserShell = "/run/current-system/sw/bin/xterm";
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";

}
