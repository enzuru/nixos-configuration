{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./modules/boot.nix
      ./modules/desktop.nix
      ./modules/dev-tools.nix
      ./modules/locale.nix
      ./modules/nix.nix
      ./modules/obs.nix
      ./modules/rocm.nix
      ./modules/security.nix
      ./modules/system-packages.nix
    ];

  nix.settings = {
    max-jobs = 12;
    cores = 12;
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  programs.fish.enable = true;

  services.openssh.enable = true;

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 32*1024;
  }];

  system.stateVersion = "25.05"; # Don't change this

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
