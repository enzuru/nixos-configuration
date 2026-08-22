{ config, pkgs, ... }:

{
  fonts.packages = with pkgs; [
    ipafont
    hanazono
    noto-fonts
  ];

  hardware.bluetooth.enable = true;

  # GNOME Shell extensions live in modules/gnome-extensions.nix.

  programs.dconf.profiles.user.databases = [{
    settings."org/gnome/desktop/input-sources".xkb-options = [ "ctrl:nocaps" ];
  }];

  programs.firefox.enable = true;
  programs.wireshark = {
    enable = true;
    dumpcap.enable = true;
    usbmon.enable = true;
  };

  services.libinput.enable = true;
  services.flatpak.enable = true;
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  users.users.enzuru = {
    isNormalUser = true;
    extraGroups = [ "wheel" "wireshark" ];
  };

  users.users.enzuru.packages = with pkgs; [
    # Adwaita
    biblioteca
    eyedropper
    fractal
    gnome-builder
    gnome-sound-recorder
    polari
    resources
    shortwave
    wike

    # GTK
    deluge
    gimp
    thunderbird

    # QT
    inkscape

    # Unfree
    discord
    google-chrome
    obsidian

    # Other
    godot
  ];

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };
}
