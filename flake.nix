{
  description = "A nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
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
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
      ];
      perSystem =
        { system, ... }:
        let
          nixvimLib = nixvim.lib.${system};
          nixvim' = nixvim.legacyPackages.${system};
          pkgs = nixpkgs.legacyPackages.${system};
          lib = pkgs.lib;
          baseNixvimModule = {
            inherit system; # or alternatively, set `pkgs`
            module = import ./config; # import the module directly
            # You can use `extraSpecialArgs` to pass additional arguments to your module files
            extraSpecialArgs = {
              # inherit (inputs) foo;
            };
          };
          jsNixvimModule = {
            inherit system pkgs; # or alternatively, set `pkgs`
            module =
              { pkgs, ... }:
              {
                imports = [
                  ./config
                  ./config/js
                ];
              };
            extraSpecialArgs = {
              # inherit (inputs) foo;
            };
          };
          pythonNixvimModule = {
            inherit system pkgs; # or alternatively, set `pkgs`
            module =
              { pkgs, ... }:
              {
                imports = [
                  ./config
                  ./config/python
                ];
              };
            extraSpecialArgs = {
              # inherit (inputs) foo;
            };
          };
          nvim = nixvim'.makeNixvimWithModule baseNixvimModule;
          jsNvim = nixvim'.makeNixvimWithModule jsNixvimModule;
          pythonNvim = nixvim'.makeNixvimWithModule pythonNixvimModule;
        in
        {
          formatter = pkgs.nixfmt-tree;
          checks = {
            # Run `nix flake check .` to verify that your config is not broken
            default = nixvimLib.check.mkTestDerivationFromNixvimModule baseNixvimModule;
          };

          packages =
            let
              aliasVimBinary =
                drv: name:
                drv.overrideAttrs (oa: {
                  pname = name;
                  meta = (oa.meta or { }) // {
                    mainProgram = name;
                  };
                  postFixup = (oa.postFixup or "") + ''
                    ln -sf $out/bin/nvim $out/bin/${name}
                  '';
                });
            in
            {
              # Lets you run `nix run .` to start nixvim
              default = nvim;
              js = aliasVimBinary jsNvim "nvim-js";
              python = aliasVimBinary pythonNvim "nvim-python";
            };
        };
    };
}
