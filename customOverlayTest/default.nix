let
  pkgs = import <nixpkgs> {
    overlays = [
      (self: super: {
        customPackage = import ./customPackage.nix;
      })
    ];
  }; 
in
rec {
  hello = pkgs.callPackage ./mySimpleNixPackage.nix { };

}

