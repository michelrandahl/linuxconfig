# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

# NOTE: you might be able to find older versions of this configuration
# by following the symlinks under this directory `ls -l /nix/var/nix/gcroots/auto/`
# the old builds are called something like `/nix/var/nix/profiles/system-xx-link/`

{ config, pkgs, ... }:
let
  essentialPackages = with pkgs; [
    acpilight
    alacritty # terminal with vim bindings
    brightnessctl
    curl
    file # cli tool for reading file metadata
    gcc
    git
    gnumake # default linux 'make' program
    htop
    killall
    man-pages
    nix-prefetch-git
    openresolv
    openssh
    openssl
    openvpn
    patchelf # useful tool patching binaries in NixOs when they don't point to correct libraries
    tree # view directory and file strucutes as tree in terminal
    unzip
    usbutils
    wget
    xorg.xmodmap # used to repurpose caps-lock key to be used as super key
    xterm
    zip
  ];

  audioPackages = with pkgs; [
    ncpamixer # TUI for handling audio volumes, used with the new pipewire setup
    spotify
  ];

  audioTools = with pkgs; [
    #bitwig-studio
    #vcv-rack
    alsa-utils # provides the `aplay` tool
    audacity
    ffmpeg
    mediainfo
    sonic-visualiser
  ];

  # sudo -i nix-channel --add https://nixos.org/channels/nixpkgs-unstable unstable
  # sudo -i nix-channel --update unstable

  unstable = import "/nix/var/nix/profiles/per-user/root/channels/unstable" {};

  unstable_packages = with unstable; [
    xclip
  ];

  neovimParsers = pkgs.tree-sitter.withPlugins (_: pkgs.tree-sitter.allGrammars);

  editorPackages = with pkgs; [
    neovimParsers
    neovim
    ripgrep # `rg`, grep tool used neovim telescope plugin
  ];

  programmingLanguages = with pkgs; [
    lua
    python3
  ];

  terminalTools = with pkgs; [
    csvkit # handy terminal tools such as `csvlook`
    direnv # tool for automatically sourcing '.envrc' in directories
    entr # program that can perform actions on file changes
    jq
    picocom # communicate with external embedded stuff
    pwgen # password generator tool
    ranger # a TUI filemanager
    ruplacer # tool for easy search and replace in code `ruplacer <word> <word-replacement>`
    silver-searcher # use `ag` to grep through code bases
    tldr # brief man-pages
    yq # jq equivalent for yaml files.. Also contains `xq` for xml
    zoxide # a change-directory (cd) alternative with the command `z`
  ];

  guiPrograms = with pkgs; [
    baobab # tool for visualizing disk usage
    brave # browser
    gimp
    inkscape
    libreoffice
    qiv # image viewer
    vlc # video player
    zathura # pdf reader
  ];

  miscPackages = with pkgs; [
    _1password-cli # cli tool for password manager
    feh # set background wallpaper
    p7zip
    pciutils
    pcmanfm # light-weight GUI filemanager for the rare occasion when its needed
    picom # window compositor for transparency
    pinentry-tty # used in conjunction with gnupg (gpg) for signing git commits
    poppler_utils # contains the tool pdfunite for appending pdf documents
    scrot # screenshot program
    xcalib
    xz # file compression tool
    picoscope
  ];

in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # https://github.com/thiagokokada/nix-alien
      # ./nix-alien.nix

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
    options = "--delete-older-than 60d";
  };

  nix.optimise = {
    automatic = true;
    dates = ["weekly"];
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices.root = {
    device = "/dev/disk/by-uuid/92018b79-7045-4ef4-949d-81b774631556";
    preLVM = true;
    allowDiscards = true;
  };
  boot.kernelModules = [ "usbtmc" ]; # needed by picoscope
  # boot.kernelModules = [ "wireguard" ];

  networking = {
    # enableIPv6 = false; # to get vpn working
    # Also disable IPv6 on all interfaces
    # interfaces = {
    #   wlp2s0.ipv6.addresses = [];
    # };

    hostName = "michel-x1";
    networkmanager = {
      enable = true;
      dns = "default";
    };

    # DNS 9.9.9.9 from Quad9 which is a Swiss-based non-profit organization
    # DNS 91.239.100.100 from UncensoredDNS based in Denmark
    # DNS 1.1.1.1 is cloudflare
    nameservers = [ "91.239.100.100" "9.9.9.9" "1.1.1.1" ];
  };

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  programs.direnv.enable = true;
  programs.java.enable = true;
  programs.bash = {
    shellAliases = {
      audio = "ncpamixer";
    };
  };
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-tty;
  };
  programs.ssh.startAgent = true;

  programs.steam = {
    enable = true;
    # remotePlay.openFirewall = true; # Optional: allows streaming to other devices
    # dedicatedServer.openFirewall = true; # Optional: for hosting multiplayer games
  };

  # Steam requires these for full functionality
  # hardware.opengl = {
  #   enable = true;
  #   # driSupport = true;
  #   driSupport32Bit = true; # Needed for Steam's 32-bit games
  # };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    packages = with pkgs; [
      source-code-pro
      dejavu_fonts
      ipafont
      corefonts
      nerd-fonts.hack
      nerd-fonts.sauce-code-pro
      # (nerdfonts.override { fonts = [ "Hack" "SourceCodePro" ]; })
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
      # STM32 NUCLEO-L073RZ development and STM32 NUCLEO-F303ZE development
      SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="374b", MODE:="666"

      # olimex programmer
      SUBSYSTEM=="usb", ATTR{idVendor}=="15ba", ATTR{idProduct}=="002b", MODE:="666"

      # zsa keyboards
      KERNEL=="hidraw*", ATTRS{idVendor}=="3297", MODE="0664", GROUP="plugdev"
      # Rule for all ZSA keyboards
      SUBSYSTEM=="usb", ATTR{idVendor}=="3297", GROUP="plugdev"
      # Rule for the Voyager
      SUBSYSTEM=="usb", ATTR{idVendor}=="3297", ATTR{idProduct}=="1977", GROUP="plugdev"
      # Keymapp Flashing rules for the Voyager
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="3297", MODE:="0666", SYMLINK+="ignition_dfu"

      # PicoScope 2000 series
      SUBSYSTEM=="usb", ATTR{idVendor}=="0ce9", ATTR{idProduct}=="1007", MODE="0666", GROUP="plugdev"

      # ASUS BT500 Bluetooth adapter
      SUBSYSTEM=="usb", ATTR{idVendor}=="0b05", ATTR{idProduct}=="190e", MODE="0666", GROUP="plugdev"

      # BetaFPV Air65 / STM32 Flight Controllers
      SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="5740", MODE="0666", GROUP="plugdev"
      # Also cover the DFU mode (bootloader mode for flashing)
      SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="df11", MODE="0666", GROUP="plugdev"

      # Radiomaster Pocket Joystick
      SUBSYSTEM=="usb", ATTR{idVendor}=="1209", ATTR{idProduct}=="4f54", MODE="0666", GROUP="plugdev"
    '';
    openssh.enable = true;
    acpid.enable = true; # power management utility

    xserver = {
      autorun = true;
      enable = true;
      xkb.layout = "us";
      displayManager = {
        lightdm.enable = true;
      };
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          dmenu
          i3blocks
          i3lock-color
          i3status
          acpi
          sysstat
        ];
      };
    };
    libinput.enable = true; # touchpad
  };

  hardware = {
    keyboard.zsa.enable = true;
    bluetooth = {
      enable = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
    enableAllFirmware = true;
    #graphics.enable = true; # replacement for `opengl.enable = true;`
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    # pulseaudio.enable = false; # experimenting with using pipewire instead of pulseaudio
  };
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    # enabling compatibility layers
    alsa.enable = true;
    alsa.support32Bit = true; # TODO needed?
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
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

  security.rtkit.enable = true; # give privileges to audio processing to avoid lag
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
      programmingLanguages ++
      guiPrograms ++
      terminalTools ++
      audioPackages ++
      audioTools ++
      miscPackages ++
      unstable_packages;
      variables = {
        EDITOR = "nvim";
        BROWSER = "brave";
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
