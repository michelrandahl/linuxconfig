# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  essentialPackages = with pkgs; [
    # vnstat # track internet data usage
    _1password # cli tool for password manager
    acpilight
    baobab # tool for visualizing disk usage
    brightnessctl
    curl
    entr # program that can perform actions on file changes
    file # cli tool for reading file metadata
    gcc
    git
    gnumake # default linux 'make' program
    htop
    killall
    man-pages
    openconnect # required to use vpn at work
    openssh
    openvpn
    p7zip
    patchelf # useful tool patching binaries in NixOs when they don't point to correct libraries
    procps # pkill and kill command
    pwgen # password generator tool
    termite
    tree # view directory and file strucutes as tree in terminal
    unzip
    usbutils
    wget
    xbindkeys # required to disable middle-click paste
    xdotool # required to disable middle-click paste
    xsel # required to disable middle-click paste 
    xterm
    zip
  ];
  audioPackages = with pkgs; [
    jack2
    pavucontrol
    qjackctl
    spotify
  ];
  audioTools = with pkgs; [
    audacity
    baudline # spectogram viewer
    bitwig-studio
  ];
  # unstable = import "/nix/var/nix/profiles/per-user/root/channels/nixos-unstable" {};
  editorPackages = with pkgs; [
    emacs
    neovim
    vimPlugins.vimproc # used by spacevim
  ];
  developerPackages = with pkgs; [
    awscli
    cabal-install # haskell package tool
    cargo # Rust tool, used by vim plugin vim-clap
    clojure
    clojure-lsp
    clojure-lsp 
    direnv # tool for automatically sourcing '.envrc' in directories
    dotnet-sdk
    elixir
    elmPackages.elm
    elmPackages.elm-analyse
    elmPackages.elm-format
    elmPackages.elm-language-server
    elmPackages.elm-test
    ghc # haskell compiler
    graphviz
    groff # used by awscli man pages
    hy
    idris
    jq
    leiningen
    lua
    nodejs
    perl
    plantuml # tool for 'writing' software diagrams
    python3
    python37Packages.virtualenv
    ripgrep # grep tool used by vim plugin vim-clap
    silver-searcher
    sqlite
    stack # haskell package tool
    tig
  ];
  miscPackages = with pkgs; [
    gimp
    google-chrome
    inkscape
    libreoffice
    feh # set background wallpaper
    pciutils
    perl530Packages.ImageExifTool # 'exiftool' image metadata extraction cli tool
    picocom
    qiv
    qutebrowser # browser with vim bindings
    scrot # screenshot program
    simplescreenrecorder
    vlc
    xcalib
    xz # file compression tool
    zathura # pdf reader
  ];
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # sudo -i nix-channel --add https://github.com/musnix/musnix/archive/master.tar.gz musnix
      # sudo -i nix-channel --update musnix
      <musnix>
    ];

  musnix = {
    enable = true;
    # kernel.realtime = true;
    # rtirq = {
    # enable = true;
    # nameList = "snd_usb_audio snd usb  i8042";
    # highList = "snd-hrtimer rtc timer snd_usb_audio snd usb  i8042";
    # };
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 90d";
  };

  # optimise reduces Nix store disk space usage by finding identical files
  #        in the store and hard-linking them to each other. It typically reduces the size of the
  #        store by something like 25-35%. Only regular files and symlinks are hard-linked in this
  #        manner. Files are considered identical when they have the same NAR archive
  #        serialisation: that is, regular files must have the same contents and permission
  #        (executable or non-executable), and symlinks must have the same contents.
  nix.autoOptimiseStore = true;

  # backup configuration file upon rebuild
  system.copySystemConfiguration = true;

  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader = {
    grub = {
      enable = true;
      useOSProber = true;
      efiSupport = true;
      device = "nodev";
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };

  boot.initrd.luks.devices.root = {
    device = "/dev/disk/by-uuid/c382c103-6eaa-4c68-9740-9129bb7f0068";
    preLVM = true;
    allowDiscards = true;
  };

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;

  networking = {
    hostName = "michel-x1";
    enableIPv6 = true;
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Copenhagen";

  programs.java.enable = true;

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;

  environment = {
    systemPackages =
      essentialPackages ++
      editorPackages ++
      developerPackages ++
      audioPackages ++
      audioTools ++
      miscPackages;
      variables = {
        EDITOR = "nvim";
      };
      homeBinInPath = true;
      pathsToLink = [ "/libexec" ];
  };

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      source-code-pro
      dejavu_fonts
      ipafont
      corefonts
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

  # TODO: support japanese input method
  # i18n.consoleKeyMap = "us";
  # i18n.defaultLocale = "en_US.UTF-8";
  # i18n.inputMethod.enabled = "fcitx";
  # i18n.inputMethod.fcitx.engines = with pkgs.fcitx-engines; [ mozc ];

  services = {
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
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };
    bluetooth.enable = true;
    enableAllFirmware = true;
    opengl.enable = true;
  };

  security.sudo = {
    enable = true;
    configFile = ''
      Defaults env_reset
      root ALL = (ALL:ALL) ALL
      %wheel ALL = (ALL) SETENV: NOPASSWD: ALL
    '';
  };

  users.users.michel = {
    home = "/home/michel";
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "realtime" "video" "docker" "vboxusers" "dialup" ];
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}

