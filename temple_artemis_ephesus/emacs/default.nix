{ config, pkgs, lib, osConfig, ... }:

let
  cfg = config.${osConfig.networking.hostName}.home.emacs;
  pkg = pkgs.callPackage
    (
      { emacsWithPackagesFromUsePackage }:
      (emacsWithPackagesFromUsePackage {
        package = pkgs.emacs-unstable;
        config = ./config.el;
        alwaysEnsure = true;

      })
    )
    { };

in
{
  options.${osConfig.networking.hostName}.home.emacs.enable = lib.mkEnableOption "emacs";

  config = lib.mkIf cfg.enable {
    home = { 
      file.".emacs".source = ./config.el;

    packages =  [

      pkg

      pkgs.nixpkgs-fmt

      # Provides:
      # vscode-html-language-server
      # vscode-css-language-server
      # vscode-json-language-server
      # vscode-eslint-language-server
      pkgs.nodePackages.vscode-langservers-extracted

      pkgs.ccls
      pkgs.nodePackages.bash-language-server
      pkgs.nodePackages.typescript pkgs.nodePackages.typescript-language-server

      # Python
      pkgs.pyright
      pkgs.ruff
      pkgs.ruff-lsp

      # Nix LSP
      pkgs.nil
      pkgs.nixd

      pkgs.openscad-lsp
      pkgs.openscad

      pkgs.texlab
      pkgs.yaml-language-server
      pkgs.gopls
      pkgs.rust-analyzer
    ];
  };

};
}
