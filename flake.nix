{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = {
          default = pkgs.dockerTools.buildLayeredImage {
            name = "server";
            contents = pkgs.writeShellScriptBin "server" ''
              #!/usr/bin/env bash

              echo "Hello, world!"
            '';
          };
        };
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            nixpkgs-fmt
            docker-compose
          ];
        };

      }
    );
}
