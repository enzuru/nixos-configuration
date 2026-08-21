{ config, pkgs, ... }:

{
  users.users.enzuru = {
    isNormalUser = true;
    description = "إلياس خانزاده";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
    packages = with pkgs; [
      exercism
      fish
      gnugo
    ];
  };
}
