{
  description = "Nixos common modules";

  inputs = {
  };

  outputs = { self, nixpkgs }: {
    nixosModules = {
      nix = import ./nix.nix;
      common = import ./common.nix;
      hardware = import ./hardware.nix;
      laptop = import ./laptop.nix;
    };
  };
}
