{
  description = "Main system configuration flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flakelight = {
      url = "github:nix-community/flakelight";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = { flakelight, nixpkgs, ... }:
    flakelight ./. {
	nixosConfigurations.nixos = {
        	system = "x86_64-linux";
        	modules = [{ system.stateVersion = "23.11"; } 
				./configuration.nix ];
	};


      legacyPackages = pkgs: pkgs;
      devShell = pkgs: {
	packages = [ pkgs.vim ];
	};
    };
}
