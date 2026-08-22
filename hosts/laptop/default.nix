{ config, pkgs, lib, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # nix.settings.max-jobs/cores are left unset so they default to "auto" and
  # follow whatever CPU this machine turns out to have.

  # Caps Lock as Ctrl — the cramped built-in keyboard wants it; the desktop
  # has a real keyboard and keeps Caps Lock. The dconf setting drives the
  # GNOME Wayland session, the xkb option covers XWayland, GDM and locale1,
  # and console.useXkbConfig carries it to the TTYs.
  programs.dconf.profiles.user.databases = [{
    settings."org/gnome/desktop/input-sources".xkb-options = [ "ctrl:nocaps" ];
  }];

  services.xserver.xkb.options = "ctrl:nocaps";
  console.useXkbConfig = true;

  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 16*1024;
  }];

  # Replace with whatever nixos-generate-config emits during the install.
  system.stateVersion = "26.05";

  # Suspend/hibernate are intentionally left enabled here; the desktop
  # disables them in hosts/desktop/default.nix.
}
