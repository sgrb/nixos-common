{ config, pkgs, lib, options, ... }:
let
  nixpkgs = config.nixpkgs.location;
in
{
  options = {
    nixpkgs.location = lib.mkOption {
      description = "nixpkgs location";
      type = lib.types.str;
    };
  };

  environment.etc."nix/nixpkgs".source = "${nixpkgs}";
  nix = {
    registry.nixpkgs.flake = nixpkgs;
    nixPath = [
      "nixpkgs=/etc/nix/nixpkgs"
    ];
  };
}
