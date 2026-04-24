{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.modules.shell;
in
{
  options.modules.shell = with types; {
    type = mkOption {
      type = enum [
        "zsh"
        "bash"
        # TODO: "fish"
      ];
      default = "zsh";
      description = "Shell type to user's liking.";
    };

    direnv = mkEnableOption "direnv support";
  };

  config = lib.mkMerge [
    # Defaults
    {
      programs = {
        # command not found for nix
        nix-index.enable = true;

        # prettier terminal prompt
        starship = {
          enable = true;
          settings = {
            battery.disabled = true;
          };
        };
      };
    }

    # Shell preferences
    (lib.mkIf (cfg.type == "bash") {
      programs = {
        bash = {
          completion.enable = true;
          vteIntegration = true;
        };

        nix-index.enableBashIntegration = true;
      };
    })

    (lib.mkIf (cfg.type == "zsh") {
      programs = {
        # Installing zsh for system
        zsh = {
          enable = true;
          vteIntegration = true;
          enableCompletion = true;

          # History file
          histSize = 5000;

          # Autosuggestions
          autosuggestions = {
            enable = true;
            highlightStyle = "fg=gray";
          };

          # ZSH Syntax Highlighting
          syntaxHighlighting = {
            enable = true;
            highlighters = [
              "main"
              "brackets"
              "pattern"
            ];
            patterns = {
              "rm -rf *" = "fg=white,bold,bg=red";
            };
            styles = {
              default = "none";
              unknown-token = "fg=gray,underline";
              reserved-word = "fg=cyan,bold";
              suffix-alias = "fg=green,underline";
              global-alias = "fg=green,bold";
              precommand = "fg=green,underline";
              commandseparator = "fg=blue,bold";
              autodirectory = "fg=green,underline";
              path = "bold";
              path_pathseparator = "";
              path_prefix_pathseparator = "";
              globbing = "fg=blue,bold";
              history-expansion = "fg=blue,bold";
              command-substitution = "none";
              command-substitution-delimiter = "fg=magenta,bold";
              process-substitution = "none";
              process-substitution-delimiter = "fg=magenta,bold";
              single-hyphen-option = "fg=green";
              double-hyphen-option = "fg=green";
              back-quoted-argument = "none";
              back-quoted-argument-delimiter = "fg=blue,bold";
              single-quoted-argument = "fg=yellow";
              double-quoted-argument = "fg=yellow";
              dollar-quoted-argument = "fg=yellow";
              rc-quote = "fg=magenta";
              dollar-double-quoted-argument = "fg=magenta,bold";
              back-double-quoted-argument = "fg=magenta,bold";
              back-dollar-quoted-argument = "fg=magenta,bold";
              assign = "none";
              redirection = "fg=blue,bold";
              comment = "fg=black,bold";
              named-fd = "none";
              numeric-fd = "none";
              arg0 = "fg=cyan";
              bracket-error = "fg=red,bold";
              bracket-level-1 = "fg=blue,bold";
              bracket-level-2 = "fg=green,bold";
              bracket-level-3 = "fg=magenta,bold";
              bracket-level-4 = "fg=yellow,bold";
              bracket-level-5 = "fg=cyan,bold";
              cursor-matchingbracket = "standout";
            };
          };

          # Extra Features
          setOptions = [
            "AUTO_CD"
            "BEEP"
            "HIST_BEEP"
            "HIST_EXPIRE_DUPS_FIRST"
            "HIST_FIND_NO_DUPS"
            "HIST_IGNORE_ALL_DUPS"
            "HIST_IGNORE_DUPS"
            "HIST_REDUCE_BLANKS"
            "HIST_SAVE_NO_DUPS"
            "HIST_VERIFY"
            "INC_APPEND_HISTORY"
            "INTERACTIVE_COMMENTS"
            "MAGIC_EQUAL_SUBST"
            "NO_NO_MATCH"
            "NOTIFY"
            "NUMERIC_GLOB_SORT"
            "PROMPT_SUBST"
            "SHARE_HISTORY"
          ];
        };

        direnv.enableZshIntegration = true;
        nix-index.enableZshIntegration = true;
      };

      # All users default shell must be zsh
      users.defaultUserShell = pkgs.zsh;

      # System configurations
      environment = {
        shells = with pkgs; [ zsh ];
        pathsToLink = [ "/share/zsh" ];
      };
    })

    # Direnv
    (lib.mkIf cfg.direnv {
      # Automatic flake devShell loading
      programs.direnv = {
        enable = true;
        silent = true;
        loadInNixShell = false;
        nix-direnv.enable = true;
      };
    })
  ];
}
