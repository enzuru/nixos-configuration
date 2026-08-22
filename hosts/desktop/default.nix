{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/obs.nix
  ];

  # Tiling only on the big screen; the laptop stays on stock GNOME.
  local.gnomeExtensions = [ pkgs.gnomeExtensions.paperwm ];

  # Tuned to this box's core count; the laptop leaves these at "auto".
  nix.settings = {
    max-jobs = 4;
    cores = 4;
  };

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 32*1024;
  }];

  system.stateVersion = "25.05"; # Don't change this

  # Always-on box: sleeping interrupts long builds and drops SSH. Deliberately
  # NOT in common.nix — a laptop needs these targets intact for lid-close.
  systemd = {
    targets = {
      sleep = { enable = false; unitConfig.DefaultDependencies = "no"; };
      suspend = { enable = false; unitConfig.DefaultDependencies = "no"; };
      hibernate = { enable = false; unitConfig.DefaultDependencies = "no"; };
      "hybrid-sleep" = { enable = false; unitConfig.DefaultDependencies = "no"; };
    };
  };
}
