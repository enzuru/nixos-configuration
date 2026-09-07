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

  # The Realtek RTL8852BE (rtw89) stalls and drops its link when PCIe ASPM L1
  # and the driver's own power-save mode are active. Turning all three off is
  # the upstream workaround, and NetworkManager's powersave switch stops it
  # from re-enabling 802.11 power save on each connection.
  boot.extraModprobeConfig = ''
    options rtw89_pci disable_aspm_l1=y disable_aspm_l1ss=y disable_clkreq=y
    options rtw89_core disable_ps_mode=y
  '';

  networking.networkmanager.wifi.powersave = false;

  # Replace with whatever nixos-generate-config emits during the install.
  system.stateVersion = "26.05";

  # Suspend/hibernate are intentionally left enabled here; the desktop
  # disables them in hosts/desktop/default.nix.
}
