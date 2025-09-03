{ config, pkgs, ... }:

{
    imports = [ ./hardware-configuration.nix ./cachix.nix ];

    networking.hostName = "mikel-laptop-nixos";
    networking.networkmanager.enable = true;
    # Enables wireless support via wpa_supplicant.
    # networking.wireless.enable = true;
    hardware.bluetooth.enable = true;

    hardware.graphics = { enable = true; };
    services.xserver.videoDrivers = ["nvidia"];
    hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = false;
        powerManagement.finegrained = false;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    system.stateVersion = "25.05";
    system.autoUpgrade = { enable = true; };

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    users.users.mikel = {
        isNormalUser = true;
        description = "Michael Lambert";
        extraGroups = [ "networkmanager" "wheel" ];
        packages = with pkgs; [ ];
    };

    time.timeZone = "America/New_York";

    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
    };

    xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
    services.xserver.enable = true;

    services.displayManager.sddm = {
        enable = true;
        wayland = { enable = true; };
        package = pkgs.kdePackages.sddm;
        extraPackages = [pkgs.sddm-astronaut];
        theme = "sddm-astronaut-theme";
    };
    services.xserver.xkb = {
        layout = "us";
        variant = "";
    };

    services.printing.enable = true;
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };
    services.blueman.enable = true;
    programs.hyprland.enable = true;
    programs.niri.enable = true;
    programs.git = {
        enable = true;
    };

    # List packages installed in system profile. To search, run: $ nix search wget
    environment.systemPackages = with pkgs; [
        wget
        home-manager
        curl
        openssl
        python3
        gcc
        gnumake
        wl-clipboard
        kdePackages.qtsvg
        kdePackages.qtmultimedia
        kdePackages.qtvirtualkeyboard
        (pkgs.sddm-astronaut.override { embeddedTheme = "purple_leaves"; })
    ];
}

