{ config, pkgs, lib, options, ... }:
{
  imports = [
    ./nix.nix
  ];
  config = {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
      "unrar"
    ];

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

    security.wrappers = let pmWrapper = name: {
      source = "${pkgs.pmount}/bin/${name}";
      owner = "root";
      group = "root";
      setuid = true;
    };
                        in
                          {
                            pmount = pmWrapper "pmount";
                            pumount = pmWrapper "pumount" ;
                          };
    environment.homeBinInPath = true;
    environment.enableAllTerminfo = true;
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      wget
      file
      lsof
      psmisc
      atop
      htop
      btop
      tcpdump
      inetutils
      whois
      pmount
      tcptraceroute
      mtr
      dnsutils
      nmap
      pv
      unzip
      zip
      lz4
      unrar
      pwgen

      python3Packages.ipython
      python3Packages.pip
      python3

      gdb
      strace
      binutils
      openssl
      man-pages
      subversion
      gitFull
      colordiff
      jq
    ];

    programs.vim.defaultEditor = true;
    programs.vim.enable = true;

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;
  };
}
