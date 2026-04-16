{ config, pkgs, lib, ... }:

{
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
}
