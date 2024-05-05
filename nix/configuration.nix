# Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./nixosModules/hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking.hostName = "nineveh";

  # Set your time zone.
  time.timeZone = "America/Argentina/Buenos_Aires";

  # Enable sound.
    sound.enable = true;
    hardware.pulseaudio.enable = true;

#  services.pipewire.enable = true;
#  services.pipewire.audio.enable = true;
#  services.pipewire.pulse.enable = true;
#  services.pipewire.alsa.enable = true;
#  services.pipewire.wireplumber.enable = true;

  #Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Define a user account. Needs to be set here before being set in home-manager 
  users.users.sieyes = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "networkmanager" "audio" ]; # wheel enables ‘sudo’ for the user.
  };

  # Allow closed-source packages
  nixpkgs.config.allowUnfree = true;
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    git
    sway
    pavucontrol
    pulseaudio
    keyd
  ];

	services.keyd = {
		enable = true;
		keyboards = {
			default = {
				ids = [ "*" ];
				settings = {
					main = {
						"4"  = "e";
						rightcontrol = "rightshift";
						rightalt = "#";
					};#.
					shift = {
						rightalt = "$";
					};
				};
		
			};
		};
	};


  environment.variables.EDITOR = "vim";


  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };


  #Enable the gnome-keyring secrets vault.
  services.gnome.gnome-keyring.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  networking.firewall.enable = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

