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
    man-pages
    openconnect # required to use vpn at work
    openssh
    openvpn
    patchelf # useful tool patching binaries in NixOs when they don't point to correct libraries
    pwgen # password generator tool
    termite # terminal with vim bindings
    tree # view directory and file strucutes as tree in terminal
    unzip
    vnstat # track internet data usage
    wget
    xterm
  ];
  audioPackages = with pkgs; [
    jack2
    pavucontrol
    qjackctl
    spotify
  ];
  audioTools = with pkgs; [
    audacity # advanced audio editor
    baudline # spectogram viewer
    bitwig-studio
  ];
  # unstable = import "/nix/var/nix/profiles/per-user/root/channels/nixos-unstable" {};
  editorPackages = with pkgs; [
    emacs
    neovim
  ];
  developerPackages = with pkgs; [
    awscli
    cabal-install # haskell package tool
    clojure
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
    idris
    jq # query and pretty print json files
    leiningen
    lua
    nodejs
    perl
    plantuml # tool for 'writing' software diagrams
    python3
    python37Packages.virtualenv
    silver-searcher # search in code with 'ag'
    sqlite
    stack # haskell package tool
    tig # view graphs of a git repository
  ];
  miscPackages = with pkgs; [
    gimp
    google-chrome
    inkscape
    libreoffice
    pciutils
    perl530Packages.ImageExifTool # 'exiftool' image metadata extraction cli tool
    qiv # simple image viewer
    qutebrowser # browser with vim bindings
    scrot # screenshot program
    virtualbox
    virtualboxWithExtpack
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

  # ensure correct system configuration to be able to use audio tools with low latency (QJackCTL doesn't work without this)
  musnix.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 90d";
  };

  # backup configuration file upon rebuild
  system.copySystemConfiguration = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # handle encrypted root partition
  boot.initrd.luks.devices.root = {
    device = "/dev/disk/by-uuid/f01a6887-4dcd-4b62-b1bd-04229c189415";
    preLVM = true;
    allowDiscards = true;
  };

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
      homeBinInPath = true; # make scripts in ~/bin accessible
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
    vnstat.enable = true; # track datausage

    xserver = {
      autorun = true;
      enable = true;
      layout = "us";
      displayManager.lightdm.enable = true;
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
    extraGroups = [ "wheel" "networkmanager" "audio" "realtime" "video" "docker" "vboxusers" ];
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
  system.stateVersion = "20.03"; # Did you read the comment?

}
