{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, emacs-overlay }:
    let
      # The system is inferred from each host's nixpkgs.hostPlatform, and the
      # hostname from the attribute name, so adding a machine is one line below
      # plus a hosts/<name>/ directory.
      mkHost = hostName: nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/${hostName}
          ./common.nix
          { networking.hostName = hostName; }
          { nixpkgs.overlays = [ emacs-overlay.overlays.default ]; }
        ];
      };
    in
    {
      nixosConfigurations = {
        desktop = mkHost "desktop";
        laptop = mkHost "laptop";
      };
    };
}
