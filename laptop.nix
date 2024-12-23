{ config, pkgs, lib, options, ... }:
{
  imports = [
    ./hardware.nix
  ];
  config = {
    environment.systemPackages = with pkgs; [
        fprintd
#        firefoxPackages.librewolf
        firefox
        chromium

        libreoffice
        hunspellDicts.en-us-large
        hunspellDicts.ru-ru
        hyphen
        vimHugeX
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
  programs.gnupg.agent = {
    pinentryPackage = pkgs.pinentry-qt;
    enable = true;
  };

  programs.ssh = {
    agentPKCS11Whitelist = "${pkgs.yubico-piv-tool}/lib/*,/var/run/current-system/sw/lib/*";
    startAgent = true;
  };

  services.upower = {
    enable = true;
  };

  services.fprintd.enable = true;

  services.printing.enable = true;

  services.tlp.enable = true;

  hardware.pulseaudio.enable = true;
  services.pipewire.enable = false;

  # Enable touchpad support.
  services.libinput.enable = true;

  services.hardware.bolt.enable = true;
 };
}