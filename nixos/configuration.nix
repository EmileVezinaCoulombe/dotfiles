# Help
# man configuration.nix
# nixos-help

{ config, pkgs, ... }:

let
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
in
{
  # man configuration.nix or on https://nixos.org/nixos/options.html.
  system.stateVersion = "24.11";

  imports =
    [
      ./hardware-configuration.nix
    ];

  ################################################################################
  # Nix
  nix = {
    nixPath = [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "nixos-config=/home/emile/.dotfiles/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
      "/home/emile/.dotfiles/nixos/"
    ];
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org/"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
    };
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 15d";
    };
  };

  ################################################################################
  # Bootloader
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  ################################################################################
  # Network
  networking = {
    hostName = "emile-nixos";
    networkmanager.enable = true;
  };

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  ################################################################################
  # System Location & Internalization
  time.timeZone = "America/Toronto";

  console.keyMap = "fr";

  i18n = {
    defaultLocale = "en_CA.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  ################################################################################
  # Desktop Environment

  services.desktopManager.cosmic.enable = true;
  services.displayManager = {
    cosmic-greeter.enable = true;
    # autoLogin = {
    #   enable = true;
    #   user = "emile";
    # };
  };
  services.system76-scheduler.enable = true;
  environment.sessionVariables = {
    COSMIC_DATA_CONTROL_ENABLED = "1"; # Disable Wayland window clipboard boundary security feature
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  programs.firefox = {
    enable = true;
    preferences = {
      # disable libadwaita theming for Firefox
      "widget.gtk.libadwaita-colors.enabled" = false;
    };
  };

  ################################################################################
  # Keymaps
  services.xserver = {
    xkb = {
      layout = "fr";
      variant = "us";
    };
  };

  ################################################################################
  # Services

  # Printer
  services.printing.enable = true;

  # Touchpad
  services.libinput.enable = true;

  #  SSH
  services.openssh.enable = true;

  # Sound
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    #media-session.enable = true;
  };

  ################################################################################
  # GPU
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = true;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
        # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  systemd.services = {
    nvidia-suspend.enable = true;
    nvidia-hibernate.enable = true;
    nvidia-resume.enable = true;
  };

  boot.kernelParams = [
    "nvidia-drm.modset=1"
    "nvidia-drm.fbdev=1"
  ];

  ################################################################################
  # System Packages
  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    curl
  ];

  ################################################################################
  # Programs

  programs.zsh.enable = true;
  programs.fzf.fuzzyCompletion = true;
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  ################################################################################
  # User
  # Don't forget to set a password with 'passwd'.
  users.users.emile = {
    isNormalUser = true;
    description = "emile";
    extraGroups = [ "networkmanager" "wheel" "video" ];

    shell = pkgs.zsh;
    packages = with pkgs; [
      # !#########################################################################
      # # To search a package:
      # $ nix search wget
      # %#########################################################################
      # nix-zsh-completions
      # zsh-autocomplete
      # zsh-autopair
      # zsh-autosuggestions
      # zsh-completions
      # zsh-forgit
      # zsh-syntax-highlighting
      # zsh-system-clipboard
      # zsh-vi-mode
      # zsh-you-should-use
      # zsh-z
      bat
      btop
      clang
      cmake
      dunst # Notifications
      eza
      fd
      firefox
      fzf
      gcc
      gh
      ghostty
      git
      gnumake
      go
      lazygit
      lua
      luajitPackages.luarocks
      micro
      neofetch
      neovim
      nodejs_22
      php
      python3
      ripgrep
      rustup
      starship # zsh
      stow
      tmux
      unstable.orca-slicer
      unzip
      waybar # Hyperland
      wofi # App launcher
      yazi
      zplug
      zsh
      zulu # java
    ];
  };
}
