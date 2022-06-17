# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  essentialPackages = with pkgs; [
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
    nix-prefetch-git
    openconnect # required to use vpn at work
    openssh
    openvpn
    p7zip
    patchelf # useful tool patching binaries in NixOs when they don't point to correct libraries
    procps # pkill and kill command
    pwgen # password generator tool
    termite # truly mouse free terminal
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
    #bitwig-studio
  ];
  # sudo -i nix-channel --add https://nixos.org/channels/nixpkgs-unstable unstable
  # sudo -i nix-channel --update unstable
  unstable = import "/nix/var/nix/profiles/per-user/root/channels/unstable" {};
  unstable_packages = with unstable; [
    fennel # a lisp dialect for Lua
    neovim # getting neovim from unstable so we can get version 0.5
  ];
  editorPackages = with pkgs; [
    emacs
    # neovim
    ripgrep # `rg`, grep tool used neovim telescope plugin
    # vimPlugins.vim-clap
  ];
  developerPackages = with pkgs; [
    # groff # used by awscli man pages?
    aws-adfs
    awscli2
    cabal-install
    clojure
    clojure-lsp
    direnv # tool for automatically sourcing '.envrc' in directories
    docker
    elixir
    # elmPackages.elm
    # elmPackages.elm-analyse
    # elmPackages.elm-format
    # elmPackages.elm-language-server
    # elmPackages.elm-test
    ghc # haskell compiler
    graphviz
    hy # lisp dialect of python
    idris
    jq
    leiningen
    lua
    # nodePackages.purescript-language-server
    # nodejs
    plantuml # tool for 'writing' software diagrams
    postgresql
    # purescript
    python3
    python39Packages.virtualenv
    silver-searcher
    spago
    sqlite
    tig
    visualvm # java profiler
    yq # jq equivalent for yaml files.. Also contains `xq`
  ];
  miscPackages = with pkgs; [
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
    slack
    vifm
    vlc # video player
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
  nix.autoOptimiseStore = true; # is this causing the nix slowness?

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
    device = "/dev/disk/by-uuid/b230b1b4-1276-43a7-8608-8c120d0f8d70";
                                
    preLVM = true;
    allowDiscards = true;
  };

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;

  # fixing issue with nix being crazy slow https://github.com/NixOS/nix/issues/5441
  networking.hosts."127.0.0.1" = [ "this.pre-initializes.the.dns.resolvers.invalid." ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking = {
    hostName = "michel-x1";
    enableIPv6 = true;
    networkmanager.enable = true;
  };

  time.timeZone = "Europe/Copenhagen";

  programs.java.enable = true;

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  virtualisation.docker.enable = true;

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
      };
      homeBinInPath = true;
  };

  fonts = {
    fontDir.enable = true;
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
    clamav = {
      daemon. enable = true;
      updater.enable = true;
    };
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
    extraGroups = [
      "wheel"
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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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
  system.stateVersion = "21.05"; # Did you read the comment?

}

