# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs.linuxPackages_latest.extend (self: super: {
  #   kernel = super.kernel.overrideAttrs (oldAttrs: {
  #     src = pkgs.lib.cleanSource /home/enzuru/src/linux;
  #   });
  # });
  # system.nixos.tags = lib.mkAfter [ "magic-trackpad-fix" ];

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
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
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

  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr
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
      blender
      ccls
      clang
      clinfo
      emacs-pgtk
      fractal
      elixir
      elixir_ls
      fish
      fish-lsp
      gimp
      glances
      gnugo
      gnumake
      gnome-builder
      go
      gopls
      ghc
      haskell-language-server
      inkscape
      mc
      nodejs
      typescript-language-server
      obsidian
      radeontop
      rustc
      rust-analyzer
      ruby
      solargraph
      sbcl
      thunderbird
      tree-sitter
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
    mg
    gnomeExtensions.paperwm
    gnome-tweaks
  ];

  programs.firefox.enable = true;
  programs.fish.enable = true;

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
