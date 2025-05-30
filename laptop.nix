{ config, pkgs, lib, options, ... }:
{
  imports = [
    ./hardware.nix
  ];
  config = {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
      "corefonts"
      "zoom-us"
      "zoom"
      "faac" # needed for zoom-us
      "unrar"
      "font-bh-lucidatypewriter"
      "font-bh-lucidatypewriter-75dpi"
    ];

    environment.systemPackages = with pkgs; [
      fprintd
      #        firefoxPackages.librewolf
      firefox
      chromium

      libreoffice
      hunspellDicts.en-us-large
      hunspellDicts.ru-ru
      hyphen
      emacs-gtk
      gimp
      inkscape
      evince
      mplayer mpv
      vlc
    ];

    fonts.packages = (with pkgs; [
      dejavu_fonts
      liberation_ttf
      corefonts
      ttf_bitstream_vera
      carlito
      iosevka
      iosevka-comfy.comfy-wide
      iosevka-comfy.comfy
    ]);

    programs.vim.package = pkgs.vimHugeX;

    programs.gnupg.agent = {
      pinentryPackage = pkgs.pinentry-qt;
      enable = true;
    };

    programs.ssh = {
      agentPKCS11Whitelist = "${pkgs.yubico-piv-tool}/lib/*,/var/run/current-system/sw/lib/*";
      startAgent = true;
    };

    programs.firefox = {
      enable = true;
      languagePacks = [ "ru" ];
      nativeMessagingHosts.packages = [ pkgs.browserpass ];
    };

    services.upower = {
      enable = true;
      criticalPowerAction = "Hibernate";
    };

    services.fprintd.enable = true;

    services.printing.enable = true;

    services.tlp.enable = true;

    services.pulseaudio.enable = true;
    services.pipewire.enable = false;

    # Enable touchpad support.
    services.libinput.enable = true;

    services.hardware.bolt.enable = true;

    services.xscreensaver.enable = config.services.xserver.enable;
  };
}
