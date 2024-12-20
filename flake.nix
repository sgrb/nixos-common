{
  description = "Nixos common modules";

  inputs = {
  };

  outputs = { self, nixpkgs }: {
    nixosModules.flakeSupport = import ./flake-support.nix;
  };
}
