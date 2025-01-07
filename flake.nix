{ description = "Tiled, scrollable window management for GNOME Shell";

  inputs."nixpkgs".url = github:NixOS/nixpkgs;

  outputs = { self, nixpkgs, flake-utils, ... }:
  flake-utils.lib.eachDefaultSystem
    (system:
    let pkgs = import nixpkgs { inherit system; };
    in
    { packages.default = pkgs.callPackage ./default.nix {};
      packages.vm = self.nixosConfigurations.testbox.config.system.build.vm;

      nixosConfigurations."testbox" =
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./vm.nix
            { nixpkgs.overlays = [
                (self: super: { paperwm = self.packages.${system}.default; })
              ];
            }
          ];
        };
    });
}
