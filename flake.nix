{
  description = "NixOS configuration";

  inputs = {
   # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
   nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

	nixvim = {
        url = "github:nix-community/nixvim";
        inputs.nixpkgs.follows = "nixpkgs";
    };


  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
	nixvim,
    ...
  }: let
    env = import hanging_gardens_babylon/nineveh;
    hostName = env.nixosVars.hostName;
	mainUser = env.nixosVars.mainUser;
    lighthouse_alexandria = import ./lighthouse_alexandria { lib = nixpkgs.lib; };
  in {
    nixosConfigurations = {
      #the following variable name must be the current host's variable name, otherwise will raise an error
      ${hostName} = nixpkgs.lib.nixosSystem {
        system = env.nixosVars.system;
        specialArgs = env;
        modules = [
          {
            networking.hostName = env.nixosVars.hostName;
            time.timeZone = env.nixosVars.timeZone;
          }
          ./zeus_olympia
          {
            options.nineveh.system.home-manager.enable = nixpkgs.lib.mkEnableOption "home manager"; #todo: turn home-manager into an option to be able to modularize zeus_olympia/bluetooth.nix
            config.${hostName}.system = lighthouse_alexandria.stringListToEnabledOptions env.nixosVars.modulesToEnable; #in charge of setting the nixosModule options
          }
         # make home-manager as a module of nixos so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`


          home-manager.nixosModules.home-manager
          ({ config, lib, ... }:
          let 
            inherit env;
		inherit hostName;
		mainUser = env.nixosVars.mainUser;
          in
        {
            home-manager = lib.mkIf config.${hostName}.system.home-manager.enable { 
              useGlobalPkgs = true;
              useUserPackages = true;
extraSpecialArgs = env;
              users.${mainUser} = {
                imports = [
			 ./temple_artemis_ephesus
			nixvim.homeManagerModules.nixvim
		 ];
                home = {
                  username = mainUser;
                  homeDirectory = "/home/${mainUser}";
                  stateVersion = "23.11";
                };
                programs.home-manager.enable = true;
                ${hostName}.home = lighthouse_alexandria.stringListToEnabledOptions env.homeVars.pkgSets;
              };
            };
          })
	

   #      home-manager.zeus_olympia.home-manager 
   #      ({ config, lib, ... }:
   #      {
   #      home-manager = 
   #      let
   #        mainUser = env.nixosVars.mainUser;
   #      in nixpkgs.lib.mkIf (config.networking.hostName.homeManager.enable == "true") {
   #           useGlobalPkgs = true;
   #           useUserPackages = true;
   #           extraSpecialArgs = env;
   #           users.${mainUser} = {
   #             imports = [
   #               ./temple_artemis_ephesus
   #             ];

   #             home = {
   #               username = mainUser;
   #               homeDirectory = "/home/${mainUser}";
   #               stateVersion = "23.11";
   #             };
   #             programs.home-manager.enable = true;
   #           ${hostName}.home = lighthouse_alexandria.stringListToEnabledOptions env.homeVars.pkgSets; #in charge of setting the homeModule options
   #           };
   #         };
   #       })
        ];
      };
    };
  };
}
