{ config, lib, pkgs, nixosVars, ... }:

{

  system.nixos.label = "testing"; 

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
  };

  programs.light.enable = true;

  sound.enable = true; 
  hardware.pulseaudio.enable = true;

  nix = {
    #automatic garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    #enable flakes
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    settings = {
      sandbox = "relaxed";
      auto-optimise-store = true;

      substituters = [
	"https://nix-community.cachix.org"
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment = {
    variables = {
      EDITOR = "nvim";
    };
    systemPackages = with pkgs; [
      curl
      git
      pavucontrol
      pulseaudio
      keyd
    ];

  };

  hardware.opengl.enable = true; #needed for sway

  users.users.${nixosVars.mainUser} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "networkmanager" "audio" "video"]; #wheel enables sudo for user; video allows controlling backlight
    shell = pkgs.fish;
  };
  services.openssh.enable = true;
  system.stateVersion = "23.11";
}
