{ config, pkgs, lib, options, ... }:
{
  options = {
    nixpkgs.stablePkgs = lib.mkOption {
      description = "nixpkgs location for stable override";
      type = with lib.types; nullOr attrs;
    };

    nixpkgs.stableOverride = lib.mkOption {
      description = "List of package names to take from stablePkgs";
      type = with lib.types; listOf str;
      default = [];
    };
  };

  config = {
    nix = {
      daemonIOSchedClass = "idle";
      daemonCPUSchedPolicy = "idle";
      # trustedBinaryCaches = [ "https://nixcache.reflex-frp.org" ];
      # binaryCachePublicKeys = [ "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI=" ];
      settings = {
        auto-optimise-store = true;
        experimental-features = ["nix-command" "flakes"];
      };
      channel.enable = false;
    };

    nixpkgs.overlays = [
      (self: super:
        super.lib.genAttrs config.nixpkgs.stableOverride (n : config.nixpkgs.stablePkgs."${n}")
      )
    ];

    environment.systemPackages = with pkgs; [
        nix-tree
        nixd
        nix-output-monitor
        nvd
    ];

    programs.nix-index.enable = true;
    programs.nix-index.enableBashIntegration = false;
    programs.command-not-found.enable = false;
    programs.nh.enable = true;
  };
}
