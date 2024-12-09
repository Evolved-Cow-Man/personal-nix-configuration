{
  inputs = {
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
  };

  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations.mySystem = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # Adjust based on your system architecture
        modules = [
        ./configuration.nix  # Your main system configuration
        ];
    };
  };
}
