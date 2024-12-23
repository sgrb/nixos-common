{ config, pkgs, lib, options, ... }:
{
  imports = [
    ./nix.nix
  ];
  config = {
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
      pmount
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
