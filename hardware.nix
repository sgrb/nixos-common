# For real hardware installation
{ config, pkgs, lib, options, ... }:
let
  resumeDev = config.fileSystems."/".device;
in {
  imports = [
    ./common.nix
  ];

  options = {
  };

  config = {
    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot";

    boot.resumeDevice = resumeDev;
    boot.kernelParams = [ "resume=${resumeDev}" ];

    # needed for resume from swap file
    boot.initrd.systemd.enable = true;

    boot.extraModprobeConfig = ''
                             options cfg80211 ieee80211_regdom="RU"
                               '';

    # Select internationalisation properties.
    i18n = {
      defaultLocale = "ru_RU.UTF-8";
    };

    console = {
      font = "LatArCyrHeb-16";
      keyMap = "ru";
    };

    # Set your time zone.
    time.timeZone = "Europe/Moscow";

    swapDevices = [
      {
        device = "/swap";
        size = 16 * 1024;
      }
    ];

    hardware.enableRedistributableFirmware = true;
    hardware.firmware = [pkgs.firmwareLinuxNonfree];

    hardware.usb-modeswitch.enable = true;

    hardware.bluetooth.enable = true;
    hardware.bluetooth.package = pkgs.bluez;

    hardware.wirelessRegulatoryDatabase = true;

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    networking.useDHCP = false;
    networking.networkmanager.enable = true;
    networking.networkmanager.plugins = (with pkgs; [
      networkmanager-openvpn
    ]);

    environment.systemPackages = with pkgs; [
      blueman
      bluez-tools

      pciutils
      ethtool
      iw
      usbutils
      usb-reset
      usb-modeswitch
      wirelesstools
      dmidecode
      linuxPackages.cpupower
      alsa-tools
      alsa-utils
      smartmontools
    ];

    services.blueman.enable = true;

    services.resolved.enable = true;
    services.resolved.extraConfig = "DNSStubListenerExtra=127.0.0.1";
  };
}
