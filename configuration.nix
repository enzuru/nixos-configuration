# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  myEmacs = (pkgs.emacsPackagesFor pkgs.emacs-git-pgtk).emacsWithPackages (epkgs: with pkgs; [
    clang-tools
    elixir-ls
    fish-lsp
    gopls
    haskell-language-server
    pyright
    rust-analyzer
    solargraph
    typescript-language-server
  ]);
  blenderRocm = pkgs.pkgsRocm.blender;
in

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    max-jobs = 4;
    cores = 4;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModulePackages = with config.boot.kernelPackages; [
    xpadneo
  ];
  # boot.kernelPackages = pkgs.linuxPackages_latest.extend (self: super: {
  #   kernel = super.kernel.overrideAttrs (oldAttrs: {
  #     src = /home/enzuru/src/linux;
  #   });
  # });
  # system.nixos.tags = lib.mkAfter [ "magic-trackpad-fix" ];

  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "65536";
    }
    {
      domain = "*";
      type = "hard";
      item = "nofile";
      value = "524288";
    }
  ];

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
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

  services.flatpak.enable = true;
  services.libinput.enable = true;
  services.locate.enable = true;
  services.locate.interval = "minutely";
  services.mozillavpn.enable = true;
  services.openssh.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.printing.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  systemd = {
    targets = {
      sleep = { enable = false; unitConfig.DefaultDependencies = "no"; };
      suspend = { enable = false; unitConfig.DefaultDependencies = "no"; };
      hibernate = { enable = false; unitConfig.DefaultDependencies = "no"; };
      "hybrid-sleep" = { enable = false; unitConfig.DefaultDependencies = "no"; };
    };
  };

  documentation.dev.enable = true;

  hardware.amdgpu.opencl.enable = true;
  hardware.cpu.amd.updateMicrocode = true;
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr
    libva
  ];
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  users.users.enzuru = {
    isNormalUser = true;
    description = "Ahmed Khanzada";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
    packages = with pkgs; [
      autoconf
      appstream
      awscli
      biblioteca
      blenderRocm
      blueprint-compiler
      btop
      checkov
      claude-code
      clang
      clinfo
      discord
      myEmacs
      eyedropper
      exercism
      fractal
      elixir
      fish
      flatpak-builder
      gdb
      gimp
      glances
      gnugo
      gnumake
      gnome-builder
      gnome-sound-recorder
      go
      godot
      guile
      ghc
      git-lfs
      htop
      hugo
      inkscape
      jq
      lsof
      mc
      nodejs
      obsidian
      openmw
      openssl
      polari
      python3
      radeontop
      resources
      rustc
      ruby
      sbcl
      shortwave
      terraform
      thunderbird
      tree-sitter
      tmux
      vulkan-tools
      wike
      wireshark
    ];
  };

  fonts.packages = with pkgs; [
    ipafont
    hanazono
    noto-fonts
  ];

  environment.systemPackages = with pkgs; [
    curl
    git
    gnomeExtensions.paperwm
    mg
    wget
  ];

  programs.firefox.enable = true;
  programs.fish.enable = true;
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi
      obs-gstreamer
      obs-vkcapture
    ];
  };

  # systemd.user.services.mozillavpn-ui = {
  #   enable = true;
  #   description = "Mozilla VPN UI";
  #   wantedBy = [ "graphical-session.target" ];
  #   after = [ "graphical-session.target" ];
  #   serviceConfig = {
  #     ExecStart = "${pkgs.mozillavpn}/bin/mozillavpn";
  #     Restart = "on-failure";
  #   };
  # };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.

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
  system.stateVersion = "25.05"; # Did you read the comment?
}
