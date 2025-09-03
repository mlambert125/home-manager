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

    programs.firefox = {
        enable = true;
        policies = {
            DisableTelemetry = true;
            DisableFirefoxStudies = true;
            EnableTrackingProtection = {
                Value = "always";
                Locked = true;
                Cryptomining = true;
                Fingerprinting = true;
            };
            # Do not erase history on close
            ClearHistoryOnShutdown = {
                Value = false;
                Locked = true;
            };
            # Do not disable cookies
            NetworkCookieCookieBehavior = {
                Value = 0;
                Locked = true;
            };
            # Do not disable cache
            NetworkCookieThirdPartyNonsecureSessionOnly = {
                Value = false;
                Locked = true;
            };
            NetworkCookieThirdPartySessionOnly = {
                Value = false;
                Locked = true;
            };

            DisablePocket = true;
            DisplayBookmarksToolbar = "always";
            DefaultSearchEngine = "DuckDuckGo";
            Preferences = {
            };
        };
    };
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
    programs.btop.enable = true;
    services.udiskie = {
        enable = true;
        settings = {
            program_options = {
                file_manager = "nautilus";
            };
        };
    };
    services.dunst = {
        enable = true;
        settings = {
            global = {
                font = "Hasklug Nerd Font Light 12";
                follow = "mouse";
                width = 500;
                max_width = 500;
                height = 100;
                max_height = 500;
                indicate_hidden = "yes";
                shrink = "no";
                transparency = 0;
                notification_height = 0;
                separator_height = 2;
                padding = 8;
                horizontal_padding = 8;
                frame_width = 1;
                frame_color = "#4287f5";
                sort = "yes";
                idle_threshold = 0;

                line-height = 0;
                markup = "full";
                format = "<b>%a</b>\n<i>%s</i>\n%b";
                alignment = "center";
                vertical_alignment = "center";
                show_age_threshold = -1;
                word_wrap = "no";
                ellipsize = "middle";
                ignore_newline = "no";
                stack_duplicates = true;
                hide_duplicate_count = true;
                show_indicators = "no";
   
                icon_position = "off";

                history_length = 20;
                browser = "/home/mikel/.nix-profile/bin/firefox -new-tab";
                always_run_script = true;
                title = "Dunst";
                class = "Dunst";
                startup_notification = true;
                verbosity = "mesg";
                corner_radius = 15;
                ignore_dbusclose = false;
                mouse_left_click = "close";
                mouse_middle_click = "do_action";
                mouse_right_click = "context";
            };
            shortcuts = {
                close = "ctrl+space";
                close_all = "ctrl+shift+space";
            };
            urgency_normal = {
                background = "#202632";
                foreground = "#ffffff";
                timeout = 5;
            };
            urgency_critical = {
                background = "#ffffff";
                foreground = "#db0101";
                timeout = 0;
            };
        };
    };
    home.packages = with pkgs; [
        starship
        waybar
        walker

        libnotify
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
        "Pictures/wallpapers".source = ./wallpapers;
        "vpn-connect.sh".source = ./vpn-connect.sh;
        ".config/nvim/init.lua".source = ./nvim/init.lua;
        ".bashrc".source = ./.bashrc;

        ".config/hypr".source = ./hypr;
        ".config/waybar".source = ./waybar;
        ".config/wpaperd".source = ./wpaperd;
        ".config/walker/config.toml".source = ./walker/config.toml;
        ".config/starship.toml".source = ./starship.toml;
    };

    home.sessionVariables = {
        HYPRCURSOR_THEME = "Catppuccin-Macchiato-Rosewater-Cursors"; 
        TERM = "kitty";
    };
}
