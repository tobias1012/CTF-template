{
  description = "CTF flake template";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.poetry2nix.url = "github:nix-community/poetry2nix";

  outputs = { self, nixpkgs, flake-utils, poetry2nix }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};

      inherit (poetry2nix.lib.mkPoetry2Nix { inherit pkgs; }) mkPoetryEnv;
      pythonEnv = mkPoetryEnv {
	python = pkgs.python311;
	projectDir = ./.;
      };

      deps = with pkgs;[
          python311
	  poetry
	  pwntools
	  pwncat
	  gdb
	  pwndbg

	  pythonEnv
      ];


      fhs = pkgs.buildFHSUserEnv {
	name = "fhs-shell";
	targetPkgs = pkgs: deps;
      };

      fhsScript = pkgs.writeShellScriptBin "fhs" "nix develop .#fhs";
    in {
      devShells.default = pkgs.mkShell {
        packages = deps ++ [fhsScript];
      };

      devShells.fhs = fhs.env;
    });
}
