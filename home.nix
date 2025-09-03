{ config, pkgs, ... }:

{
    home.stateVersion = "25.05"; # Please read the comment before changing.
    home.username = "mikel";
    home.homeDirectory = "/home/mikel";
    nixpkgs.config.allowUnfree = true;
    fonts.fontconfig.enable = true;

    nixpkgs.overlays = [
        (import (builtins.fetchTarball { url = "https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz"; }))
    ];
    
    # Set the cursor theme for both X and Wayland.
    home.pointerCursor = {
        package = pkgs.catppuccin-cursors;
        name = "Catppuccin-Mocha-Mauve-Cursors"; # Use the correct theme name
        size = 24;
        gtk.enable = true;
        x11.enable = true;
    };

    programs.git = {
        enable = true;
        userName = "Michael Lambert";
        userEmail = "mlambert125@live.com";
        extraConfig = {
            pull.rebase = false;
            init.defaultBranch = "main";
            core.editor = "nvim";
            credential.helper = "store";
            push.autoSetupRemote = true;
        };
    };

    programs.firefox.enable = true;
    programs.home-manager.enable = true;
    programs.fish.enable = true;
    programs.kitty = {
        enable = true;
        font = {
            name = "Hasklug Nerd Font Light";
            size = 14;
        };
        extraConfig = ''
            font_family Hasklug Nerd Font Light
            bold_font Hasklug Nerd Font Light
            italic_font Hasklug Nerd Font Light

            shell_integration enabled
            confirm_os_window_close 0 
            map kitty_mod+t new_tab_with_cwd
        '';
    };
    programs.vscode = {
        enable = true;
        profiles.default = {
            extensions = with pkgs.vscode-extensions; [
                ms-dotnettools.csharp
            ];
        };
    };

    home.packages = with pkgs; [
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
        llvm
        lldb
        netcoredbg
        omnisharp-roslyn

        nerd-fonts.hasklug
        catppuccin-cursors.mochaMauve
        blueberry

        walker
        waybar
        wpaperd
        hyprlock
        nautilus
        hypridle
        hyprlock
        hyprshot
        playerctl
        cmake
        pavucontrol

        neovim
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
        bitwarden-desktop
        filezilla
        mongodb-compass
    ];

    home.file = {
        ".bashrc".source = ./.bashrc;
        "vpn-connect.sh".source = ./vpn-connect.sh;
        ".config/nvim/init.lua".source = ./nvim/init.lua;
        ".config/hypr".source = ./hypr;
        ".config/hyprpanel".source = ./hyprpanel;
        ".config/waybar".source = ./waybar;
        ".config/wpaperd".source = ./wpaperd;
        ".config/walker/config.toml".source = ./walker/config.toml;
        "Pictures/wallpapers".source = ./wallpapers;
        ".config/starship.toml".source = ./starship.toml;
    };

    home.sessionVariables = {
        HYPRCURSOR_THEME = "Catppuccin-Macchiato-Rosewater-Cursors"; 
    };
}
