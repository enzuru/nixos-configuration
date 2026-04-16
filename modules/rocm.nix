{ config, pkgs, ... }:

let
  blenderRocm = pkgs.pkgsRocm.blender;
  myPython = pkgs.python3.withPackages (ps: [
    (ps.torch.override { rocmSupport = true; })
  ]);
in

{
  hardware.amdgpu.opencl.enable = true;
  hardware.cpu.amd.updateMicrocode = true;
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr
    libva
  ];

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  users.users.enzuru.packages = [
    blenderRocm
    myPython
    pkgs.rocmPackages.rocminfo
    pkgs.radeontop
    pkgs.clinfo
    pkgs.vulkan-tools
  ];
}
