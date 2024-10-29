{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-doom-emacs-unstraightened.url = "github:marienz/nix-doom-emacs-unstraightened";

    vault-secrets = {
      url = "github:serokell/vault-secrets/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay.url = "github:nix-community/emacs-overlay/master";

    nineveh.url = "github:nrs-status/nineveh";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    nixvim,
    vault-secrets,
    nix-doom-emacs-unstraightened,
    emacs-overlay,
    nineveh,
    ...
  }: let
    env = import hanging_gardens_babylon/nineveh;
    system = env.nixosVars.system;
    overlaylessNixpkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    hostName = env.nixosVars.hostName;
    helpers = import ./lighthouse_alexandria {
      pkgs = overlaylessNixpkgs;
      inherit system;
      lib = overlaylessNixpkgs.lib;
      nixvim = inputs.nixvim;
    }; #all of these are passed because helpers contains the function that builds derivations from pkg.nix files in temple
    defaultOverlay = final: prev: helpers.createAttrsFromCustomPackagingFiles ./temple_artemis_ephesus;
    pkgs = import nixpkgs {
        system = env.nixosVars.system;
        config.allowUnfree = true;
        overlays = [defaultOverlay];
      };
  in {
    overlays.default = defaultOverlay;
    packages = pkgs;
#    packages."x86_64-linux" = {
#      nixvim = pkgs.nixvim
#    };
    apps."x86_64-linux" = {
      "nvim" = {
        type = "app";
        program = "${self.packages.nixvim}/bin/nvim";
      };
      "test" = {
        type = "app";
        program = pkgs.lib.getExe self.packages.hello;
      };
    };
    nixosConfigurations = nineveh.nineveh
  };
}
