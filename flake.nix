{
  description = "CTF flake template";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.poetry2nix.url = "github:nix-community/poetry2nix";

  outputs = { self, nixpkgs, flake-utils, poetry2nix }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      deps = with pkgs;[
          python311
	  pwntools
	  pwncat
	  pwndbg
      ];

      inherit (poetry2nix.lib.mkPoetry2Nix { inherit pkgs; }) mkPoetryEnv;
      pythonEnv = mkPoetryEnv {
	python = pkgs.python311;
	projectDir = ./.;
      };

      fhs = pkgs.buildFHSUserEnv {
	name = "fhs-shell";
	targetPkgs = pkgs: deps ++ [pythonEnv];
      };
    in {
      devShells.default = pkgs.mkShell {
        packages = deps ++ [pythonEnv];
	shellHook = ''
	'';
      };

      devShells.fhs = fhs.env;
    });
}
