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
      emacs = import ./emacs.nix;
      grafana = import ./grafana.nix;
    };

    # Пакеты-скрипты. В systemPackages не попадают: хост берёт их явно,
    # например `common.packages.x86_64-linux.mpi`.
    overlays.scripts = import ./packages/scripts.nix;

    packages = nixpkgs.lib.genAttrs [ "x86_64-linux" ] (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        import ./packages/scripts.nix { inherit (pkgs) lib; } pkgs pkgs);
  };
}
