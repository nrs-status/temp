{lib, ...} @ inputs: let
  lighthouse_alexandria = import ../lighthouse_alexandria inputs;
  allNixFilesExceptFirstDefault = lighthouse_alexandria.recursivelyListNixFilesExceptThoseInIgnoreList {
    dir = ./.;
    ignore = [./default.nix];
  };
  filteringKeepingDefaultDotNixFiles = lib.filter (x: lib.hasSuffix "default.nix" x) allNixFilesExceptFirstDefault;
  topLevelFilter = x: baseNameOf (dirOf (dirOf x)) == "temple_artemis_ephesus";
  filteringKeepingTopLevelDefaultFiles = builtins.filter topLevelFilter filteringKeepingDefaultDotNixFiles;
in
  # @NOTE: Additional modules must be at least staged in git
  {
    inherit allNixFilesExceptFirstDefault;
    inherit filteringKeepingDefaultDotNixFiles;
    inherit filteringKeepingTopLevelDefaultFiles;
  }
