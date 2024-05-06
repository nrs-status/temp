{ lib, ... }:
with lib;
let
  # Filters out directories that don't end with .nix or are this file, also makes the strings absolute
  indexNixFiles = { ignore, dir }:
    (filter
      (file:
        let
	#lib.path.removePrefix does: /some/path -> ./path
	#lib.removePrefix does: ./some/path -> some/path
          getSuffixlessBasename = lib.removePrefix "./" (lib.path.removePrefix dir file);
        in
        hasSuffix ".nix" file
        && getSuffixlessBasename != "default.nix"
        && ! (builtins.elem getSuffixlessBasename ignore))
      (filesystem.listFilesRecursive dir));

in
#the following will produce a list of paths
opts: indexNixFiles opts
