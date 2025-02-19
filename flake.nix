{
  description = "A user-mode driver for the Wii U GC adapter.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = {
          default = pkgs.stdenv.mkDerivation {
            pname = "wii-u-gc-adapter";
            version = "0-unstable";

            src = ./.;

            nativeBuildInputs = [ pkgs.pkg-config ];
            buildInputs = [
              pkgs.libusb1
              pkgs.systemd
            ];

            installPhase = ''
              mkdir -p $out/bin
              cp wii-u-gc-adapter $out/bin/
            '';

            meta = with pkgs.lib; {
              description = "Driver for the official Nintendo Wii U GameCube controller adapter";
              homepage = "https://github.com/ToadKing/wii-u-gc-adapter";
              license = licenses.mit;
              platforms = platforms.linux;
            };
          };
        };

        devShell.default = pkgs.mkShell {
          buildInputsFrom = [ self.packages.${system}.default ];
        };
      }
    );
}
