{ config, pkgs, lib, options, ... }:
{
  imports = [
    ./nix.nix
  ];
  config = {
    environment.homeBinInPath = true;
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      wget
      file
      lsof
      psmisc
      tcpdump
      inetutils
      whois
      tcptraceroute
      bind
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
      gitAndTools.gitFull
      colordiff
      jq
    ];

    programs.vim.defaultEditor = true;
    programs.vim.enable = true;

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;
  };
}
