{
    description = "Home Manager configuration";

    inputs = {
        # Specify the source of Home Manager and Nixpkgs.
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { nixpkgs, home-manager, ... }: {
        homeConfigurations.${builtins.getEnv "USER"} = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.${builtins.currentSystem};
            modules = [ ./home.nix ];
        };
    };
}
