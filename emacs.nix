{ config, lib, pkgs, options, ... }:
let
  isGui = config.services.displayManager.enable || config.services.xserver.enable;
in
{
  environment.systemPackages = let
    epkg = with pkgs; if isGui then emacs-gtk else emacs-nox;
    myEmacs = epkg.pkgs.withPackages (epkgs: with epkgs; [
      treesit-grammars.with-all-grammars
      tree-sitter-langs
    ]);
  in [ (lib.hiPrio myEmacs) ];
}
