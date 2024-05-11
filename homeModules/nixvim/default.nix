{
  config,
  lib,
  pkgs,
  osConfig,
  nixosVars,
  ...
}: let
  cfg = config.${osConfig.networking.hostName}.home.nixvim;
in {
  options.${osConfig.networking.hostName}.home.nixvim.enable = lib.mkEnableOption "nixvim";
  config = lib.mkIf cfg.enable {
  	home = { sessionVariables.EDITOR = "nvim";
	packages = with pkgs; [
		alejandra #for formatting nix
        ];
	};

    programs.nixvim = {
      enable = true;
	defaultEditor = true;
	plugins = {
	nvim-cmp = {
      enable = true;
      autoEnableSources = true;
#      sources = [
#        {name = "nvim_lsp";}
#        {name = "path";}
#        {name = "buffer";}
#        {name = "luasnip";}
#      ];
};

    lsp = {
      enable = true;

      servers = {
        tsserver.enable = true;

        lua-ls = {
          enable = true;
          settings.telemetry.enable = false;
        };
        rust-analyzer = {
          enable = true;
          installCargo = true;
        };
      };
    };
};
};

};
}
