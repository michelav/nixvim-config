{
  description = "A nixvim configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    {
      nixvim,
      nixpkgs,
      flake-parts,
      ...
    }@inputs:
    let
      systems = [
        "x86_64-linux"
      ];

      mkPkgs =
        system:
        import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            allowUnfreePredicate = _: true;
          };
        };

      mkNixvimModules =
        {
          system,
          spellDictionaries ? [ ],
        }:
        let
          pkgs = mkPkgs system;

          extraSpecialArgs = {
            inherit spellDictionaries;
          };

          baseNixvimModule = {
            inherit system pkgs;
            module = import ./config;
            inherit extraSpecialArgs;
          };

          jsNixvimModule = {
            inherit system pkgs;
            module =
              { ... }:
              {
                imports = [
                  ./config
                  ./config/js
                ];
              };
            inherit extraSpecialArgs;
          };

          pythonNixvimModule = {
            inherit system pkgs;
            module =
              { ... }:
              {
                imports = [
                  ./config
                  ./config/python
                ];
              };
            inherit extraSpecialArgs;
          };
        in
        {
          inherit
            baseNixvimModule
            jsNixvimModule
            pythonNixvimModule
            ;
        };

      mkNixvimPackages =
        {
          system,
          spellDictionaries ? [ ],
        }:
        let
          nixvim' = nixvim.legacyPackages.${system};

          modules = mkNixvimModules {
            inherit system spellDictionaries;
          };
        in
        {
          default = nixvim'.makeNixvimWithModule modules.baseNixvimModule;
          js = nixvim'.makeNixvimWithModule modules.jsNixvimModule;
          python = nixvim'.makeNixvimWithModule modules.pythonNixvimModule;
        };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      inherit systems;

      flake.lib = {
        inherit mkNixvimPackages;
      };

      perSystem =
        { system, ... }:
        let
          pkgs = mkPkgs system;
          nixvimLib = nixvim.lib.${system};

          modules = mkNixvimModules {
            inherit system;
          };

          packages = mkNixvimPackages {
            inherit system;
          };
        in
        {
          formatter = pkgs.nixfmt-tree;

          checks = {
            default = nixvimLib.check.mkTestDerivationFromNixvimModule modules.baseNixvimModule;
          };

          inherit packages;
        };
    };
}
