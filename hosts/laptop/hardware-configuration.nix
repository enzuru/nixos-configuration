# ┌──────────────────────────────────────────────────────────────────────────┐
# │ PLACEHOLDER — this machine has not been installed yet.                   │
# │                                                                          │
# │ It exists so `nixos-rebuild build --flake .#laptop` evaluates from the    │
# │ desktop, which catches errors in common.nix before you ever boot the      │
# │ laptop. The filesystem UUIDs below are fake and will NOT boot.            │
# │                                                                          │
# │ During the install, overwrite this file wholesale:                        │
# │   sudo nixos-generate-config --root /mnt                                  │
# │   cp /mnt/etc/nixos/hardware-configuration.nix hosts/laptop/              │
# │ and copy the stateVersion it picked into hosts/laptop/default.nix.        │
# └──────────────────────────────────────────────────────────────────────────┘
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/00000000-0000-0000-0000-000000000000";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/0000-0000";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
