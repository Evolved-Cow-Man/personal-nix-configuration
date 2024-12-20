# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }: # 'inputs' for nix-minecraft

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # for nix-minecraft
      inputs.nix-minecraft.nixosModules.minecraft-servers
    ];

  # for nix-minecraft
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  # nix minecraft setup
  services.minecraft-servers = {
    enable = true;
    eula = true;

    servers = {
      velocity-proxy = {
        enable = true;
        autoStart = true;
        restart = "always";
        package = pkgs.velocityServers.velocity;
        jvmOpts = "-XX:+UseG1GC -XX:G1HeapRegionSize=4M -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled -XX:+AlwaysPreTouch -XX:MaxInlineLevel=15";
        files."velocity.toml".value = {
          motd = "\"<white>Evolved Cow's</white>\n<b><i><rainbow>Epic Minecraft Server</rainbow></i></b>\"";
          force-key-authentication = "false";
          player-info-forwarding-mode = "\"modern\"";

          # Define your servers
          "vanilla-server" = "100.75.123.60:25566";
          "modded-server" = "100.75.123.60:25567";
          "ash-server" = "100.75.123.60:25568";

          # Forced-hosts configuration
          "vanilla.evolvedcow.net" = "vanilla-server";
          "modded.evolvedcow.net" = "modded-server";
          "ash.evolvedcow.net" = "ash-server";
        };
      };
    };
  };

  # Use the GRUB 2 boot loader. (setup for legacy boot)
  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
    useOSProber = true; # Autodetection of other OSs
  };

  networking.hostName = "nixos-proxy"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.proxy-user = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    gh
    htop
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable firewall
  networking.firewall.enable = true;
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [25565];
  networking.firewall.allowedUDPPorts = [25565];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
