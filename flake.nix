{
  description = "Caterpillar PC NixOS configuration";

  nixConfig = {
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.pc = nixpkgs.lib.nixosSystem {
      modules = [ ./configuration.nix ];
    };
  };
}
