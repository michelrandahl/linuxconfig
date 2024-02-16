# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

# NOTE: you might be able to find older versions of this configuration
# by following the symlinks under this directory `ls -l /nix/var/nix/gcroots/auto/`
# the old builds are called something like `/nix/var/nix/profiles/system-xx-link/`

{ config, pkgs, ... }:
let
  essentialPackages = with pkgs; [
    _1password # cli tool for password manager
    acpilight
    alacritty # terminal with vim bindings
    baobab # tool for visualizing disk usage
    brightnessctl
    csvkit # handy terminal tools such as `csvlook`
    curl
    entr # program that can perform actions on file changes
    file # cli tool for reading file metadata
    gcc
    git
    gnumake # default linux 'make' program
    htop
    killall
    man-pages
    nix-prefetch-git
    openssh
    openssl
    openvpn
    p7zip
    patchelf # useful tool patching binaries in NixOs when they don't point to correct libraries
    # procps # pkill and kill command
    pwgen # password generator tool
    tree # view directory and file strucutes as tree in terminal
    unzip
    usbutils
    wget
    xterm
    zip
    zoxide
  ];
  pwManager = with pkgs; [
    # `pass`: A password manager that uses GPG for encryption and Git for version control.
    # It's the core utility for managing passwords in this setup.
    pass

    # `gnupg`: GNU Privacy Guard, a complete implementation of the OpenPGP standard.
    # Required for the encryption and decryption of passwords stored by `pass`.
    gnupg

    # `pinentry`: A collection of simple PIN or passphrase entry dialogs which GnuPG uses for passphrase entry.
    # Required to securely enter passphrases for GPG keys used by `pass`.
    pinentry
  ];
  audioPackages = with pkgs; [
    jack2
    pavucontrol
    qjackctl
    spotify
  ];
  audioTools = with pkgs; [
    audacity
    #baudline # spectogram viewer
    #bitwig-studio
    ffmpeg
    #vcv-rack
  ];
  # sudo -i nix-channel --add https://nixos.org/channels/nixpkgs-unstable unstable
  # sudo -i nix-channel --update unstable
  unstable = import "/nix/var/nix/profiles/per-user/root/channels/unstable" {};
  unstable_packages = with unstable; [
    # fennel # a lisp dialect for Lua
    xclip
  ];
  neovimParsers = pkgs.tree-sitter.withPlugins (_: pkgs.tree-sitter.allGrammars);
  editorPackages = with pkgs; [
    neovimParsers
    neovim
    #neovim-qt
    ripgrep # `rg`, grep tool used neovim telescope plugin
  ];
  developerPackages = with pkgs; [
    # groff # used by awscli man pages?
    # aws-adfs
    # awscli2
    clojure
    clojure-lsp
    direnv # tool for automatically sourcing '.envrc' in directories
    docker
    graphviz
    jq
    leiningen
    lua
    # plantuml # tool for 'writing' software diagrams
    # postgresql
    python3
    python39Packages.virtualenv
    silver-searcher
    # sqlite
    # tig
    # visualvm # java profiler
    yq # jq equivalent for yaml files.. Also contains `xq`
  ];
  miscPackages = with pkgs; [
    brave
    feh # set background wallpaper
    gimp
    google-chrome
    inkscape
    libreoffice
    pciutils
    picocom
    poppler_utils # contains the tool pdfunite for appending pdf documents
    qiv # image viewer
    qutebrowser # browser with vim bindings
    scrot # screenshot program
    vlc # video player
    xcalib
    xz # file compression tool
    zathura # pdf reader
  ];
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # https://github.com/thiagokokada/nix-alien
      ./nix-alien.nix

      # sudo -i nix-channel --add https://github.com/musnix/musnix/archive/master.tar.gz musnix
      # sudo -i nix-channel --update musnix
      # <musnix>
    ];

  # musnix = {
  #   enable = true;
  #   # kernel.realtime = true;
  #   # rtirq = {
  #   # enable = true;
  #   # nameList = "snd_usb_audio snd usb  i8042";
  #   # highList = "snd-hrtimer rtc timer snd_usb_audio snd usb  i8042";
  #   # };
  # };

  nixpkgs.config = {
    allowUnfree = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 100d";
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices.root = {
    device = "/dev/disk/by-uuid/92018b79-7045-4ef4-949d-81b774631556";
    preLVM = true;
    allowDiscards = true;
  };

  networking = {
    hostName = "michel-x1";
    enableIPv6 = true;
    networkmanager.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  programs.java.enable = true;
  programs.nix-ld.enable = true;

  # this oracle Virtualbox takes ages to install, lets find another way to use it?
  # virtualisation.virtualbox.host.enable = true;
  # virtualisation.virtualbox.host.enableExtensionPack = true;
  # virtualisation.docker.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    # fonts = with pkgs; [
    packages = with pkgs; [
      source-code-pro
      dejavu_fonts
      ipafont
      corefonts
      (nerdfonts.override { fonts = [ "Hack" ]; })
    ];
    fontconfig.defaultFonts = {
      monospace = [
        "DejaVu Sans Mono"
        "IPAGothic"
      ];
      sansSerif = [
        "DejaVu Sans"
        "IPAPGothic"
      ];
      serif = [
        "DejaVu Serif"
        "IPAPMincho"
      ];
    };
  };

  services = {
    udev.extraRules = ''
      # CMSIS-DAP for microbit
      SUBSYSTEM=="usb", ATTR{idVendor}=="0d28", ATTR{idProduct}=="0204", MODE:="666"
      # STM32 NUCLEO-L073RZ development
      SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="374b", MODE:="666"

      # zsa keyboards
      KERNEL=="hidraw*", ATTRS{idVendor}=="3297", MODE="0664", GROUP="plugdev"
      # Rule for all ZSA keyboards
      SUBSYSTEM=="usb", ATTR{idVendor}=="3297", GROUP="plugdev"
      # Rule for the Voyager
      SUBSYSTEM=="usb", ATTR{idVendor}=="3297", ATTR{idProduct}=="1977", GROUP="plugdev"
      # Keymapp Flashing rules for the Voyager
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="3297", MODE:="0666", SYMLINK+="ignition_dfu"
    '';
    # anti sleep?
    # logind.lidSwitch = "ignore";
    openssh.enable = true;
    acpid.enable = true; # power management utility
    # vnstat.enable = true; # track datausage

    xserver = {
      autorun = true;
      enable = true;
      layout = "us";
      displayManager = {
        lightdm.enable = true;
        # disable pesky middle-click paste
        # setupCommands = ''
        #   echo -n | xsel -n -i; pkill xbindkeys; xdotool click 2; xbindkeys
        # '';
      };
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          dmenu
          i3blocks
          i3lock
          i3status
          acpi
          sysstat
        ];
      };
      libinput.enable = true; # touchpad
    };
  };

  hardware = {
    keyboard.zsa.enable = true;
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };
    bluetooth.enable = true;
    enableAllFirmware = true;
    opengl.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.michel = {
    home = "/home/michel";
    isNormalUser = true;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "networkmanager"
      "audio"
      "realtime"
      "video"
      "docker"
      "vboxusers"
      "dialup"
      "dialout"
      "postgres"
      "plugdev"
    ]; 
  };

  security.sudo = {
    enable = true;
    configFile = ''
      Defaults env_reset
      root ALL = (ALL:ALL) ALL
      %wheel ALL = (ALL) SETENV: NOPASSWD: ALL
    '';
  };

  environment = {
    systemPackages =
      essentialPackages ++
      editorPackages ++
      developerPackages ++
      audioPackages ++
      audioTools ++
      miscPackages ++
      unstable_packages;
      variables = {
        EDITOR = "nvim";
        BROWSER = "qutebrowser";
      };
      homeBinInPath = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # fixing issue with nix being crazy slow https://github.com/NixOS/nix/issues/5441
  # networking.hosts."127.0.0.1" = [ "this.pre-initializes.the.dns.resolvers.invalid." ];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}

