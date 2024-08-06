{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  cfg = config.${osConfig.networking.hostName}.home.git;
in {
  options.${osConfig.networking.hostName}.home.git.enable = lib.mkEnableOption "git";

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        git-crypt
        delta
        glab
        pre-commit
      ];

      sessionVariables = {PRE_COMMIT_ALLOW_NO_CONFIG = "1";};
    };

    programs = {
      git = {
        enable = true;
        package = pkgs.gitSVN;
        delta = {
          enable = true;
          options = {
            syntax-theme = "gruvbox-dark";
            features = "line-numbers";
          };
        };
        ignores = [
          "$RECYCLE.BIN/"
          "*.cab"
          "*.elc"
          "*.lnk"
          "*.msi"
          "*.msix"
          "*.msm"
          "*.msp"
          "*.rel"
          "*.stackdump"
          "*.tmp"
          "*.xlk"
          "*.~vsd*"
          "*_archive"
          "*_flymake.*"
          "*~"
          ".#*"
          ".Trash-*"
          ".cask/"
          ".dir-locals-2.el"
          ".directory"
          ".fuse_hidden*"
          ".netrwhist"
          ".nfs*"
          ".org-id-locations"
          ".projectile"
          ".stfolder"
          ".~lock.*#"
          "/.emacs.desktop"
          "/.emacs.desktop.lock"
          "/auto/"
          "/elpa/"
          "/eshell/history"
          "/eshell/lastdir"
          "/network-security.data"
          "/server/"
          "Backup of *.doc*"
          "Session.vim"
          "Sessionx.vim"
          "Thumbs.db"
          "Thumbs.db:encryptable"
          "[._]*.s[a-v][a-z]"
          "[._]*.sw[a-p]"
          "[._]*.un~"
          "[._]s[a-rt-v][a-z]"
          "[._]ss[a-gi-z]"
          "[._]sw[a-p]"
          "[Dd]esktop.ini"
          "auto-save-list"
          "dist/"
          "ehthumbs.db"
          "ehthumbs_vista.db"
          "flycheck_*.el"
          "secring.*"
          "tags"
          "tramp"
          "~$*.doc*"
          "~$*.ppt*"
          "~$*.xls*"
          ".direnv/"
        ];
        lfs.enable = true;
        userEmail = "sebaarsim@gmail.com";
        userName = "nrs-status";
        extraConfig = {
          init.defaultBranch = "master";
          commit.verbose = true;
          pull.rebase = "true";
          push = {
            default = "current";
            followtags = true;
          };
          diff = {
            algorithm = "histogram";
            colorMoved = "default";
            tool = "nvimdiff";
          };
          merge = {
            conflictstyle = "zdiff3";
            keepbackup = true;
          };
          rebase.autosquash = true;
          rerere.enabled = true;
          github.user = "nrs-status";
          url = {
            "git@github.com:".pushInsteadOf = "https://github.com/";
            "git@gitlab.com:".pushInsteadOf = "https://gitlab.com/";
            "git@codeberg.org:".pushInsteadOf = "https://codeberg.org";
          };
          transfer.fsckobjects = true;
          fetch.fsckobjects = true;
          receive.fsckObjects = true;
        };
      };
      gh = {
        enable = true;
        settings.git_protocol = "ssh";
      };
    };
  };
}
