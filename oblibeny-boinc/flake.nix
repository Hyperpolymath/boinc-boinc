{
  description = "Oblibeny BOINC Platform - Distributed Verification Infrastructure";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };

        rust-toolchain = pkgs.rust-bin.stable.latest.default.override {
          extensions = [ "rust-src" "rust-analyzer" ];
        };

      in {
        packages = {
          # Rust parser
          oblibeny-parser = pkgs.rustPlatform.buildRustPackage {
            pname = "oblibeny-parser";
            version = "0.6.0";
            src = ./rust-parser;

            cargoLock = {
              lockFile = ./rust-parser/Cargo.lock;
              allowBuiltinFetchGit = true;
            };

            nativeBuildInputs = with pkgs; [ rust-toolchain pkg-config ];
            buildInputs = with pkgs; [ ];

            meta = {
              description = "Parser and analyzer for Oblibeny language";
              license = pkgs.lib.licenses.gpl3Plus;
            };
          };

          # Elixir coordinator
          oblibeny-coordinator = pkgs.beamPackages.mixRelease {
            pname = "coordinator";
            version = "0.6.0";
            src = ./elixir-coordinator;

            mixFodDeps = pkgs.beamPackages.fetchMixDeps {
              pname = "coordinator-mix-deps";
              src = ./elixir-coordinator;
              version = "0.6.0";
              sha256 = pkgs.lib.fakeSha256; # Will need to be updated
            };

            meta = {
              description = "Elixir/OTP coordinator for BOINC work distribution";
              license = pkgs.lib.licenses.gpl3Plus;
            };
          };

          # Lean 4 proofs
          oblibeny-proofs = pkgs.stdenv.mkDerivation {
            pname = "oblibeny-proofs";
            version = "0.6.0";
            src = ./lean-proofs;

            nativeBuildInputs = with pkgs; [ lean4 ];

            buildPhase = ''
              lake build
            '';

            installPhase = ''
              mkdir -p $out/bin
              cp -r build $out/
            '';

            meta = {
              description = "Lean 4 formal proofs for Oblibeny properties";
              license = pkgs.lib.licenses.gpl3Plus;
            };
          };

          # Complete platform
          default = pkgs.symlinkJoin {
            name = "oblibeny-boinc-platform";
            paths = with self.packages.${system}; [
              oblibeny-parser
              oblibeny-coordinator
              oblibeny-proofs
            ];
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Rust development
            rust-toolchain
            cargo-watch
            cargo-edit

            # Elixir development
            elixir
            elixir_ls

            # Lean 4 development
            lean4

            # Database
            arangodb

            # Container tools
            podman
            podman-compose

            # Build tools
            cmake
            gnumake
            pkg-config

            # Version control
            git

            # Utilities
            jq
            curl
            which
          ];

          shellHook = ''
            echo "Oblibeny BOINC Development Environment"
            echo "======================================"
            echo ""
            echo "Available commands:"
            echo "  cd rust-parser && cargo build       - Build Rust parser"
            echo "  cd elixir-coordinator && mix deps.get - Get Elixir dependencies"
            echo "  cd lean-proofs && lake build        - Build Lean proofs"
            echo ""
            echo "Nix environment ready!"
          '';
        };

        # Development shells for specific components
        devShells = {
          rust = pkgs.mkShell {
            buildInputs = with pkgs; [
              rust-toolchain
              cargo-watch
              cargo-edit
              rust-analyzer
            ];
          };

          elixir = pkgs.mkShell {
            buildInputs = with pkgs; [
              elixir
              elixir_ls
              arangodb
            ];
          };

          lean = pkgs.mkShell {
            buildInputs = with pkgs; [
              lean4
            ];
          };
        };

        # NixOS module for deployment
        nixosModules.oblibeny-boinc = { config, lib, pkgs, ... }: {
          options.services.oblibeny-boinc = {
            enable = lib.mkEnableOption "Oblibeny BOINC Platform";

            package = lib.mkOption {
              type = lib.types.package;
              default = self.packages.${system}.default;
              description = "Oblibeny BOINC platform package";
            };

            arangodb = {
              url = lib.mkOption {
                type = lib.types.str;
                default = "http://localhost:8529";
                description = "ArangoDB URL";
              };

              database = lib.mkOption {
                type = lib.types.str;
                default = "oblibeny_boinc";
                description = "ArangoDB database name";
              };
            };
          };

          config = lib.mkIf config.services.oblibeny-boinc.enable {
            systemd.services.oblibeny-coordinator = {
              description = "Oblibeny BOINC Coordinator";
              wantedBy = [ "multi-user.target" ];
              after = [ "network.target" "arangodb.service" ];

              serviceConfig = {
                ExecStart = "${config.services.oblibeny-boinc.package}/bin/coordinator start";
                Restart = "always";
                User = "oblibeny";
                Group = "oblibeny";
              };

              environment = {
                ARANGO_URL = config.services.oblibeny-boinc.arangodb.url;
                ARANGO_DB = config.services.oblibeny-boinc.arangodb.database;
              };
            };

            users.users.oblibeny = {
              isSystemUser = true;
              group = "oblibeny";
              description = "Oblibeny BOINC service user";
            };

            users.groups.oblibeny = {};
          };
        };
      }
    );
}
