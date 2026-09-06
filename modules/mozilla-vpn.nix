{ config, pkgs, ... }:

let
  # xdg-desktop-portal claims its D-Bus name before it loads the backends, so a
  # client that calls too early gets the object without the interface it wants.
  # Block until org.freedesktop.portal.Secret is really there, then give up.
  waitForSecretPortal = pkgs.writeShellScript "wait-for-secret-portal" ''
    for _ in $(seq 1 60); do
      if ${pkgs.systemd}/bin/busctl --user introspect \
           org.freedesktop.portal.Desktop /org/freedesktop/portal/desktop \
           2>/dev/null | ${pkgs.gnugrep}/bin/grep -q org.freedesktop.portal.Secret; then
        exit 0
      fi
      sleep 1
    done
    echo "org.freedesktop.portal.Secret never appeared; starting anyway." >&2
    exit 0
  '';

  # The daemon answers on D-Bus only after it is activated, and the client needs
  # a moment to reach it, so retry instead of failing on the first call.
  activateTunnel = pkgs.writeShellScript "mozillavpn-activate" ''
    for _ in $(seq 1 30); do
      if ${pkgs.mozillavpn}/bin/mozillavpn activate; then
        exit 0
      fi
      sleep 2
    done
    echo "Could not activate Mozilla VPN. Run 'mozillavpn login' once." >&2
    exit 1
  '';
in
{
  # Ships the client, the D-Bus activation file and the privileged daemon unit.
  # The daemon is socket-less and starts on demand: launching the client asks
  # for org.mozilla.vpn.dbus and D-Bus activates mozillavpn.service.
  services.mozillavpn.enable = true;

  # Autostart is declarative here because the client can no longer do it itself.
  # Two facts from the logs on this machine drove the change:
  #
  # 1. gnome-session in GNOME 50 ignores X-GNOME-Autostart-Delay. All three
  #    autostart entries launched inside 5 ms, two seconds before
  #    xdg-desktop-portal.service finished starting. The client then logged
  #    "No such interface org.freedesktop.portal.Secret", fell back to
  #    QSettings, could not decrypt ~/.config/mozilla/vpn.moz, read
  #    "StartAtBoot changed: 0", and deleted its own autostart entry.
  #
  # 2. The client cannot write that entry back. xdg-desktop-portal 1.22 refuses
  #    org.freedesktop.portal.Background.RequestBackground for an unsandboxed
  #    process and logs "EnableAutostart call failed: Autostart not supported
  #    (no AppId detected)".
  #
  # So the session launches the client from a systemd user unit that first waits
  # for the Secret portal. The unit replaces ~/.config/autostart entirely, which
  # also removes the pinned /nix/store path that the portal used to write there.
  systemd.user.services.mozillavpn-ui = {
    description = "Mozilla VPN client";
    after = [ "graphical-session.target" "xdg-desktop-portal.service" ];
    wants = [ "xdg-desktop-portal.service" ];
    partOf = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStartPre = waitForSecretPortal;
      ExecStart = "${pkgs.mozillavpn}/bin/mozillavpn ui -m -s";
      Restart = "on-failure";
      RestartSec = 5;
    };
    # A second client instance exits as soon as it sees the first one. Cap the
    # restarts so that case cannot become a loop, as it did for Nextcloud.
    # These two keys belong in [Unit], not in [Service].
    unitConfig = {
      StartLimitIntervalSec = 60;
      StartLimitBurst = 3;
    };
  };

  # The account token lives in the client, not in the daemon, so the tunnel can
  # only come up after the client is running. `ui -s` already activates when the
  # client's own "Launch at startup" setting is on. This unit is the backstop
  # for the case where that setting got turned off by a past portal failure.
  systemd.user.services.mozillavpn-connect = {
    description = "Activate the Mozilla VPN tunnel";
    after = [ "mozillavpn-ui.service" ];
    requires = [ "mozillavpn-ui.service" ];
    partOf = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = activateTunnel;
    };
  };
}
