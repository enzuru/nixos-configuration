{ config, pkgs, lib, ... }:

# Everything both machines share. Host identity (hostname, hardware, power
# policy, build parallelism) lives in hosts/<name>/default.nix instead.
{
  imports =
    [
      ./modules/boot.nix
      ./modules/desktop.nix
      ./modules/dev-tools.nix
      ./modules/gnome-extensions.nix
      ./modules/locale.nix
      #./modules/mozilla-vpn.nix
      ./modules/nextcloud.nix
      ./modules/nix.nix
      ./modules/rocm.nix
      ./modules/security.nix
      ./modules/system-packages.nix
      ./modules/users.nix
    ];

  networking.networkmanager.enable = true;

  programs.fish.enable = true;

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };

  time.timeZone = "America/Los_Angeles";
}
