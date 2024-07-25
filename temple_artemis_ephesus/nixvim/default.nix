1
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  cfg = config.${osConfig.networking.hostName}.home.nixvim;
in {
  options.${osConfig.networking.hostName}.home.nixvim.enable = lib.mkEnableOption "nixvim";
  config = lib.mkIf cfg.enable {
    home = {
      sessionVariables.EDITOR = "nvim";
      packages = with pkgs; [
        nixvim

        rustywind #tailwind formatter
        stylelint #css formatter
        rubyPackages.htmlbeautifier #html formatter

        haskellPackages.cabal-fmt #cabal formatter
        fixjson #json formatter
        yamlfmt #yaml formatter

        beautysh #bash formatter
      ];
    };
  };
}
