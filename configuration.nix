{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./modules/rocm.nix
      ./modules/desktop.nix
      ./modules/obs.nix
      ./modules/dev-tools.nix
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
    max-jobs = 12;
    cores = 12;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs.linuxPackages_latest.extend (self: super: {
  #   kernel = super.kernel.overrideAttrs (oldAttrs: {
  #     src = /home/enzuru/src/linux;
  #   });
  # });
  # system.nixos.tags = lib.mkAfter [ "magic-trackpad-fix" ];

  environment.systemPackages = with pkgs; [
    git
    mg
  ];

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

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  programs.fish.enable = true;

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

  services.locate.enable = true;
  services.locate.interval = "minutely";
  services.openssh.enable = true;

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 32*1024;
  }];

  system.stateVersion = "25.05";

  systemd = {
    targets = {
      sleep = { enable = false; unitConfig.DefaultDependencies = "no"; };
      suspend = { enable = false; unitConfig.DefaultDependencies = "no"; };
      hibernate = { enable = false; unitConfig.DefaultDependencies = "no"; };
      "hybrid-sleep" = { enable = false; unitConfig.DefaultDependencies = "no"; };
    };
  };

  time.timeZone = "America/Los_Angeles";

  users.users.enzuru = {
    isNormalUser = true;
    description = "Ahmed Khanzada";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
    packages = with pkgs; [
      exercism
      fish
      gnugo
    ];
  };
}
