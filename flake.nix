{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    
   home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }: 
	let 
		env = import ./nix/envs/nineveh.nix;
	in
	{
  	nixosConfigurations = {
		nineveh = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				modules = [
				
					# make home-manager as a module of nixos so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
					home-manager.nixosModules.home-manager {
						home-manager.useGlobalPkgs = true;
						home-manager.useUserPackages = true;

						home-manager.users.sieyes =  import ./nix/home.nix;

						home-manager.extraSpecialArgs = env.homeVars;						
			        	 }
					./nix/configuration.nix
        			];
      		};
	};
  };
}
