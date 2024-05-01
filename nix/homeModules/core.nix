{ pkgs, config, lib, ... }:

let cfg = config.nineveh.home.core;
in {
  options.nineveh.home.core.enable = lib.mkEnableOption "core programs";

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        bzip2
        curl
        gnutar
        gzip
        less
        mkpasswd
        nix
        openssh
        netcat
        time
        which
        xz
	su
	vim
	tree
	which
	unzip
	htop
	ltrace
	strace
	lsof
      ]; 
    };

    nix = {
      package = pkgs.nix;
      settings = {
        auto-optimise-store = true;
        experimental-features = [ "nix-command" "flakes" ];
        # see explanation of sandbox at https://discourse.nixos.org/t/survey-how-are-you-using-flakes-today/15494/4
        sandbox = "relaxed";
        substituters =
          [ "https://cache.nixos.org" ];
        trusted-public-keys = [
        ];
      };
    };
  };
}

