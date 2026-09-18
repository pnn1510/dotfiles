{ config, pkgs, user, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
in

{
  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "24.11";
  home.packages = with pkgs; [
    # cli i use constantly
    ripgrep   # fast search
    fd        # fast find
    fzf       # fuzzy finder
    jq        # json on the command line
    lazygit
    neovim
    gh        # github cli
    uv        # python package manager
    tmux      # terminal multiplexer
    nerd-fonts.hack # the font everything renders in
    databricks-cli
    vscode
    dbeaver-bin
    colima
    docker
    docker-compose
    lazydocker
    go
    gopls
    golangci-lint
    claude-code
    peco 
  ];
  fonts.fontconfig.enable = true;
  home.sessionVariables.EDITOR = "nvim";

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;      # ghost text from history
    syntaxHighlighting.enable = true;  # commands turn green when valid
    initContent = ''
      bindkey '^f' autosuggest-accept 
      bindkey '^r' peco-select-history
    '';
    shellAliases = {
      ".." = "cd ..";
      add = "git add .";
      push = "git push";
      pull = "git pull";
      m = "git switch main";
      cc = "claude --dangerously-skip-permissions";
      co = "codex --full-auto";
    };
    # Automatically handles downloading, naming, and sourcing the custom OMZ plugin
      plugins = [
      {
        name = "zsh-peco-history";
        src = pkgs.fetchFromGitHub {
          owner = "jimeh";
          repo = "zsh-peco-history";
          rev = "master"; # Or a specific commit hash for strict reproducibility
          sha256 = "sha256-lEgisjuLrnetIUG0fXl9vH3/ZHgpyQviy7rJazCkMTs="; 
          # Tip: Leave the hash blank or wrong at first; Nix will error out and give you the correct one.
        };
        file = "zsh-peco-history.zsh";
      }
    ];

  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$cmd_duration$line_break$character";
      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
      };
      cmd_duration.format = "[$duration]($style) ";
    };
  };

  programs.obsidian = {
    enable = true;

    vaults.notes.target = "Documents/Obsidian";

    defaultSettings.app = {
      alwaysUpdateLinks = true;
      spellcheck = true;
    };
  };

  # Edit-in-place: the real file stays in my repo, ~/.config just points at it.
  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/nvim";
  home.file.".config/herdr".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/herdr";
  home.file.".config/gh".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/gh";
  home.file.".config/git".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/git";
  home.file.".config/tmux".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/tmux";
  home.file.".config/uv".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/uv";
  home.file.".config/ghostty".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/ghostty";
  home.file.".config/opencode".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/opencode";
  home.file.".claude/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.claude/settings.json";
  home.file.".claude/CLAUDE.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".codex/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
}
