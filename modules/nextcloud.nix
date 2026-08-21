{ config, pkgs, ... }:

{
  # Sync client for the Hetzner Storage Share (managed Nextcloud). Credentials
  # live in gnome-keyring after the one-time GUI login, so nothing lands here.
  users.users.enzuru.packages = with pkgs; [
    nextcloud-client
  ];

  # The client is tray-only once configured, so start it hidden per-session
  # rather than dropping a .desktop into ~/.config/autostart.
  systemd.user.services.nextcloud-client = {
    description = "Nextcloud sync client";
    after = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.nextcloud-client}/bin/nextcloud --background";
      ExecStop = "${pkgs.nextcloud-client}/bin/nextcloud --quit";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}
