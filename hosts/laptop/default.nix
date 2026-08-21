{ config, pkgs, lib, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # nix.settings.max-jobs/cores are left unset so they default to "auto" and
  # follow whatever CPU this machine turns out to have.

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 16*1024;
  }];

  # Replace with whatever nixos-generate-config emits during the install.
  system.stateVersion = "26.05";

  # Suspend/hibernate are intentionally left enabled here; the desktop
  # disables them in hosts/desktop/default.nix.
}
