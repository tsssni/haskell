{
  description = "haskell devenv";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      nixpkgs,
      ...
    }:
    let
      lib = nixpkgs.lib;

      systems = [
        "aarch64-darwin"
        "x86_64-linux"
      ];

      systemAttrs = f: system: { ${system} = f system; };

      mapSystems = f: systems |> lib.map (systemAttrs f) |> lib.mergeAttrsList;

      devShells = mapSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
          hpkgs = pkgs.haskellPackages;
          drv = hpkgs.developPackage { root = ./.; };
        in
        {
          default = (drv.envFunc { withHoogle = true; }).overrideAttrs (old: {
            shellHook = ''
              export SHELL=nu
            '';
            nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
              hpkgs.cabal-install
              pkgs.haskell-language-server
            ];
          });

          bootstrap = pkgs.mkShellNoCC {
            shellHook = ''
              export SHELL=nu
            '';
            packages = with pkgs; [
              cabal-install
              ghc
              haskell-language-server
            ];
          };
        }
      );
    in
    {
      inherit devShells;
    };
}
