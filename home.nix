{ config, pkgs, ... }:

{
    home.stateVersion = "25.05"; # Please read the comment before changing.
    home.username = "mikel";
    home.homeDirectory = "/home/mikel";
    nixpkgs.config.allowUnfree = true;
    fonts.fontconfig.enable = true;

nixpkgs.overlays = [
(import (builtins.fetchTarball {
url = "https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz";
}))
];

    home.packages = with pkgs; [
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
        dotnet-sdk_9
        lldb
        omnisharp-roslyn

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
        nerd-fonts.hasklug
    ];

    home.file = {
        ".bashrc".source = ./.bashrc;
        "vpn-connect.sh".source = ./vpn-connect.sh;
	# ".config/nvim".source = ./nvim;
        ".config/kitty".source = ./kitty;
        ".config/hypr".source = ./hypr;
        ".config/hyprpanel".source = ./hyprpanel;
        ".config/wpaperd".source = ./wpaperd;
        ".config/walker/config.toml".source = ./walker/config.toml;
        "Pictures/wallpapers".source = ./wallpapers;
        ".config/starship.toml".source = ./starship.toml;
    };

  home.sessionVariables = {
  };

  programs.home-manager.enable = true;
  programs.fish.enable = true;
}
