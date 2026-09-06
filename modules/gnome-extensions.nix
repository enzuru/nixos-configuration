{ config, lib, pkgs, ... }:

# GNOME Shell extensions, declared in one place so hosts can add their own.
#
# A dconf database holds exactly one value per key, so a second
# `programs.dconf.profiles.user.databases` entry setting enabled-extensions
# would SHADOW this list rather than extend it. Hosts must therefore add to
# `local.gnomeExtensions` instead of writing their own dconf entry.
{
  options.local.gnomeExtensions = lib.mkOption {
    type = lib.types.listOf lib.types.package;
    default = [ ];
    example = lib.literalExpression "[ pkgs.gnomeExtensions.paperwm ]";
    description = ''
      GNOME Shell extensions to install system-wide and mark enabled. List
      definitions merge, so hosts can append machine-specific extensions.
    '';
  };

  config = {
    local.gnomeExtensions = [
      # GNOME has no legacy tray; tray-only apps need this to be reachable.
      pkgs.gnomeExtensions.appindicator

      # Cosmetic: blurs the overview, panel, and dash.
      pkgs.gnomeExtensions.blur-my-shell
    ];

    environment.systemPackages = config.local.gnomeExtensions;

    programs.dconf.profiles.user.databases = [{
      settings."org/gnome/shell".enabled-extensions =
        map (e: e.extensionUuid) config.local.gnomeExtensions;
    }];
  };
}
