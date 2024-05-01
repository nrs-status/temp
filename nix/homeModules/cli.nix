{ config, lib, pkgs, ... }:

let cfg = config.nineveh.home.cli;
in {
	options.nineveh.home.cli.enable = lib.mkEnableOption "CLI programs";

	config = lib.mkIf cfg.enable {
		home = {
			packages = with pkgs; [
				bat
				fish
				tldr
				tmux
				ripgrep
				nnn
				fzf
				fd
				htop
				direnv
			];
		};
	};
}
