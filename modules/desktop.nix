{ config, pkgs, ... }:

{
  hardware.bluetooth.enable = true;

  programs.firefox.enable = true;

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

  fonts.packages = with pkgs; [
    ipafont
    hanazono
    noto-fonts
  ];

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
    wireshark

    # Unfree
    discord
    google-chrome
    obsidian

    # Other
    godot
  ];
}
