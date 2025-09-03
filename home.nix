{ config, pkgs, ... }:

{
    home.stateVersion = "25.05";
    home.username = "mikel";
    home.homeDirectory = "/home/mikel";
    nixpkgs.config.allowUnfree = true;
    fonts.fontconfig.enable = true;

    nixpkgs.overlays = [
        (import (builtins.fetchTarball { url = "https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz"; }))
    ];
    
    home.pointerCursor = {
        package = pkgs.catppuccin-cursors;
        name = "Catppuccin-Mocha-Mauve-Cursors";
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
    programs.bat.enable = true;
    programs.fd.enable = true;
    programs.fzf = {
       enable = true; 
       enableBashIntegration = true;
    };
    programs.lazygit.enable = true;
    programs.ripgrep.enable = true;
    programs.eza = {
        enable = true;
        enableBashIntegration = true;
        colors = "always";
        icons = "always";
    };
    programs.zoxide = {
        enable = true;
        enableBashIntegration = true;
    };
    programs.go.enable = true;
    programs.jq.enable = true;
    programs.java.enable = true;
    programs.hyprlock.enable = true;
    programs.obs-studio.enable = true;
    programs.lutris.enable = true;
    services.udiskie = {
        enable = true;
        settings = {
            program_options = {
                file_manager = "nautilus";
            };
        };
    };
    home.packages = with pkgs; [
        starship
        waybar

        lua5_1
        luajitPackages.luarocks
        stylua
        lua-language-server
        zip
        unzip
        rustup
        llvm
        ruby
        php
        php84Packages.composer
        nodejs_24
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
        wpaperd
        nautilus
        hypridle
        hyprlock
        hyprshot
        playerctl
        cmake
        pavucontrol

        neovim
        google-chrome
        bitwarden-desktop
        remmina
        freerdp
        vscode
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
