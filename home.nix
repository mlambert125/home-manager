{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "mikel";
  home.homeDirectory = "/home/mikel";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    neovim
    lua5_1
    luajitPackages.luarocks
    stylua
    lua-language-server
    fd
    fzf
    lazygit
    ripgrep
    zip
    unzip
    bat
    eza
    zoxide
    starship
    rustup
    llvm
    go
    ruby
    php
    php84Packages.composer
    nodejs_24
    jdk
    julia
    python312
    python312Packages.pip
    tree-sitter
    sqlite
    dotnet-sdk_6
    dotnet-sdk_7
    dotnet-sdk_9
    dotnet-sdk_10
    dotnet-runtime_6
    dotnet-runtime_7
    dotnet-runtime_9
    dotnet-runtime_10
    dotnet-aspnetcore_6
    dotnet-aspnetcore_7
    dotnet-aspnetcore_9
    dotnet-aspnetcore_10

    hypridle
    hyprlock
    hyprshot
    playerctl
    cmake

    firefox
    google-chrome
    bitwarden-desktop
    remmina
    freerdp
    obs-studio
    vscode
    lutris
    discord
    gimp3
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
    ".bashrc".source = ./.bashrc;
    "vpn-connect.sh".source = ./vpn-connect.sh
    ".config/nvim/lua".source = ./nvim/lua;
    ".config/kitty".source = ./kitty;
    ".config/hypr".source = ./hypr;
    ".config/hyprpanel".source = ./hyprpanel;
    ".config/wpaperd".source = ./wpaperd;
    ".config/walker".source = ./walker;
    "Pictures/wallpapers".source = ./wallpapers;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/mikel/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.fish.enable = true;
  programs.steam.enable = true
}
