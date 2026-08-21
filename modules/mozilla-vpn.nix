{ config, pkgs, ... }:

{
  # Ships the client, the D-Bus activation file and the privileged daemon unit.
  services.mozillavpn.enable = true;

  # The packaged unit's [Install] section is not honoured by systemd.packages,
  # so wire it up ourselves instead of relying on D-Bus activation alone.
  systemd.services.mozillavpn.wantedBy = [ "multi-user.target" ];

  # The client holds the account token, so the tunnel is brought up per-session.
  systemd.user.services.mozillavpn-ui = {
    description = "Mozilla VPN client";
    after = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.mozillavpn}/bin/mozillavpn ui --minimized";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

  systemd.user.services.mozillavpn-connect = {
    description = "Activate the Mozilla VPN tunnel";
    after = [ "mozillavpn-ui.service" ];
    requires = [ "mozillavpn-ui.service" ];
    partOf = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    path = with pkgs; [ coreutils mozillavpn ];
    # The client needs a moment to talk to the daemon after login, so retry.
    script = ''
      for _ in {1..30}; do
        if mozillavpn activate; then
          exit 0
        fi
        sleep 2
      done
      echo "Could not activate Mozilla VPN; log in once with 'mozillavpn login'." >&2
      exit 1
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}
