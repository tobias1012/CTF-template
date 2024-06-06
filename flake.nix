{
  description = "CTF flake template";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      deps = with pkgs;[
          python311
	  pwntools
	  pwncat
	  pwndbg
      ];
      fhs = pkgs.buildFHSUserEnv {
	name = "fhs-shell";
	targetPkgs = pkgs: deps;};
    in {
      devShells.default = pkgs.mkShell {
        packages = deps;
	shellHook = ''
	'';
      };

      devShells.fhs = fhs.env;
    });
}
