{ config, pkgs, ... }:

{
  # Sync client for the Hetzner Storage Share (managed Nextcloud). Credentials
  # live in gnome-keyring after the one-time GUI login, so nothing lands here.
  users.users.enzuru.packages = with pkgs; [
    nextcloud-client
  ];

  # Autostart is deliberately left to the client's own "Launch on system
  # startup" setting, which writes ~/.config/autostart/Nextcloud.desktop with a
  # profile-relative Exec, so it survives rebuilds and GC. A systemd user
  # service was tried and reverted: the client exits 255 when another instance
  # already holds its lock, which Restart=on-failure turned into a permanent
  # restart loop.
}
