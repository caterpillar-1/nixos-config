# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  nix.settings.experimental-features = ["nix-command" "flakes"];

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernel
  boot.kernel = {
    sysctl = {
      "vm.swappiness" = 10;
    };
  };

  networking.hostName = "pc"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-rime
    ];
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ctp = {
    isNormalUser = true;
    description = "Caterpillar";
    extraGroups = [ "networkmanager" "wheel" "wireshark" "docker" ];
    packages = with pkgs; [
    ];
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "ctp";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # NTP
  services.timesyncd = {
    servers = [
      "0.cn.pool.ntp.org"
      "1.cn.pool.ntp.org"
      "2.cn.pool.ntp.org"
      "3.cn.pool.ntp.org"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Nix
    nix-tree

    # File formats
    ## archives
    gnutar zip gzip p7zip unrar bzip2 xz
    ## magic
    file

    # CLI
    ## shell
    bash zsh nushell
    ## shell utils
    busybox
    findutils diffutils gnused gnugrep gawk
    ## editor
    vim

    # Monitor
    htop iftop iotop-c btop powertop radeontop 
    sysstat

    # Programming
    ## common
    git
    ## C/C++ lang
    gcc clang pkg-config ccache 
    ## debugging
    strace ltrace

    # Networking
    wget curl
    inetutils socat
    dnsutils traceroute whois
    ethtool tcpdump
    nmap

    # Hardware
    ## disks
    parted
    smartmontools
    ## interconnect
    pciutils usbutils hwloc
    ## sensors
    lm_sensors
    ## video & accel
    libva-utils
    ## cpu
    linuxPackages.cpupower

    

    # User
    home-manager

    # fun
    cowsay
  ];

  # Needed for some local tools like uv
  environment.localBinInPath = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;

  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  programs.clash-verge = {
    enable = true;
    autoStart = true;
    tunMode = true;
    serviceMode = true;
  };

  programs.niri.enable = true;
  #programs.waybar.enable = true;

  programs.appimage = {
    enable = true;
    binfmt = true;
    package = pkgs.appimage-run.override {
      extraPkgs = (pkgs: with pkgs; [ icu ]);
    };
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv
      zlib
      fuse3
      icu
      openssl
    ];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  programs.gamemode.enable = true;

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark-qt;
    dumpcap.enable = true;
    usbmon.enable = true;
  };

  # Services
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.flatpak.enable = true;
  xdg.portal.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  virtualisation.docker.enable = true;
  virtualisation.waydroid.enable = true;
  virtualisation.virtualbox = {
    host = {
      enable = true;
      enableExtensionPack = true;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

  hardware.enableAllHardware = true;
  
  hardware.graphics = {
    enable32Bit = true;
  };

  #hardware.opentabletdriver = {
  #  enable = true;
  #  daemon.enable = true;
  #};

  hardware.gpgSmartcards.enable = true;

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            capslock = "esc";
            esc = "capslock";
          };
        };
      };
    };
  };

  services.locate.enable = true;

  services.sysprof.enable = true;

#  services.udev.extraRules = 
#    ''
#    # UGEE UE12
#    KERNEL=="hidraw*", ATTRS{idVendor}=="28bd", ATTRS{idProduct}=="290a", MODE="0666"
#    SUBSYSTEM=="usb", ATTRS{idVendor}=="28bd", ATTRS{idProduct}=="290a", MODE="0666"
#    SUBSYSTEM=="input", ATTRS{idVendor}=="28bd", ATTRS{idProduct}=="290a", ENV{LIBINPUT_IGNORE_DEVICE}="1"
#    '';

  services.logind.settings.Login = {
    lidSwitch = "ignore";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "ignore";
    powerKey = "ignore";
    powerKeyLongPress = "hibernate";
    rebootKey = "ignore";
    rebootKeyLongPress = "reboot";
    suspendKey = "lock";
    suspendKeyLongPress = "hibernate";
    hibernateKey = "lock";
    hibernateKeyLongPress = "hibernate";
  };

  services.upower = {
    enable = true;
    ignoreLid = true;
    criticalPowerAction = "Hibernate";
    percentageAction = 4;
    timeAction = 30;
  };

  systemd.user.services = {
    inhibit-suspend-on-lidswitch = {
      enable = true;
      name = "inhibit-suspend-on-lidswitch";
      wantedBy = [ "default.target" ];
      description = "Inhibit suspension on lidswitch caused by GNOME.";
      path = with pkgs; [ systemd coreutils ];
      serviceConfig = {
        ExecStart="systemd-inhibit --what=handle-lid-switch sleep 100d";
      };
    };
  };

  services.smartd.enable = true;

  services.fstrim = {
    enable = true;
    interval = "weekly";
  };
}
