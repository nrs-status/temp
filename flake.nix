{
  description = "NixOS configuration";

  inputs = {
   # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
   nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    ...
  }: let
    env = import envs/nineveh;
    hostName = env.nixosVars.hostName;
    utils = import ./utils { lib = nixpkgs.lib; };
  in {
    nixosConfigurations = {
      #the following variable name must be the current host's name, otherwise will raise an error
      ${hostName} = nixpkgs.lib.nixosSystem {
        system = env.nixosVars.system;
        specialArgs = env;
        modules = [
          {
            networking.hostName = env.nixosVars.hostName;
            time.timeZone = env.nixosVars.timeZone;
          }
          ./nixosModules
          {
          ${hostName}.system = utils.stringListToEnabledOptions env.nixosVars.modulesToEnable; #in charge of setting the nixosModule options
          }
         # make home-manager as a module of nixos so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
          home-manager.nixosModules.home-manager
          {
            home-manager = let
              mainUser = env.nixosVars.mainUser;
            in {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = env;
              users.${mainUser} = {
                imports = [
                  ./homeModules
                ];

                home = {
                  username = mainUser;
                  homeDirectory = "/home/${mainUser}";
                  stateVersion = "23.11";
                };
                programs.home-manager.enable = true;
              ${hostName}.home = utils.stringListToEnabledOptions env.homeVars.pkgSets; #in charge of setting the homeModule options
              };
            };
          }
        ];
      };
    };
  };
}
