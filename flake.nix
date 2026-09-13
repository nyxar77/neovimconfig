{
  description = "Nyxar Neovim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    /*
      fenix = {
        url = "github:nix-community/fenix";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    */
  };

  outputs =
    {
      home-manager,
      nixpkgs,
      unstable,
      ...
    }:
    let
      systems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;

      unstableOverlay =
        _final: prev:
        let
          unstablePkgs = import unstable {
            system = prev.stdenv.hostPlatform.system;
            config."allowUnfreePredicate" =
              pkg:
              builtins.elem (prev.lib.getName pkg) [
                "codex"
                "harpoon-lualine"
              ];
          };
        in
        {
          inherit (unstablePkgs) codex;
          vimPlugins = prev.vimPlugins // {
            harpoon-lualine = unstablePkgs.vimPlugins.harpoon-lualine;
            reactive-nvim = unstablePkgs.vimPlugins.reactive-nvim;
          };
        };

      pkgsFor = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          overlays = [ unstableOverlay ];
          config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [ "intelephense" ];
        }
      );

      ciHomes = forAllSystems (
        system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor.${system};
          modules = [
            ./home-manager.nix
            {
              home = {
                username = "ci";
                homeDirectory = "/home/ci";
                stateVersion = "26.05";
              };
            }
          ];
        }
      );

      packageMetadata =
        system:
        let
          config = ciHomes.${system}.config.programs.neovim;
          unwrapPlugin = entry: entry.plugin or entry;
          packages = (map unwrapPlugin config.plugins) ++ config.extraPackages;
        in
        map (pkg: {
          name = nixpkgs.lib.getName pkg;
          version = nixpkgs.lib.getVersion pkg;
          broken = pkg.meta.broken or false;
          knownVulnerabilities = pkg.meta.knownVulnerabilities or [ ];
          maintainerCount = builtins.length (pkg.meta.maintainers or [ ]);
          homepage = pkg.meta.homepage or null;
        }) packages;

      packageHealthCheck =
        system:
        let
          pkgs = pkgsFor.${system};
          metadata = pkgs.writeText "neovim-package-metadata.json" (builtins.toJSON (packageMetadata system));
        in
        pkgs.runCommand "neovim-package-health" { nativeBuildInputs = [ pkgs.jq ]; } ''
          cp ${metadata} "$out"

          if jq -e '[.[] | select(.broken or (.knownVulnerabilities | length > 0))] | length > 0' "$out" >/dev/null; then
            echo "Broken or vulnerable packages:" >&2
            jq -r '.[] | select(.broken or (.knownVulnerabilities | length > 0)) | "- \(.name)-\(.version): \(.knownVulnerabilities | join(", "))"' "$out" >&2
            exit 1
          fi

        '';
    in
    {
      overlays.default = unstableOverlay;
      homeManagerModules.default = import ./home-manager.nix;

      packages = forAllSystems (system: {
        default = ciHomes.${system}.config.programs.neovim.finalPackage;
        neovim = ciHomes.${system}.config.programs.neovim.finalPackage;
        home-activation = ciHomes.${system}.activationPackage;
        package-metadata = packageHealthCheck system;
      });

      checks = forAllSystems (system: {
        neovim = ciHomes.${system}.config.programs.neovim.finalPackage;
        home-manager = ciHomes.${system}.activationPackage;
        package-health = packageHealthCheck system;
      });

      devShells = forAllSystems (system: {
        ci = pkgsFor.${system}.mkShellNoCC {
          packages = with pkgsFor.${system}; [
            actionlint
            deadnix
            gitleaks
            hyperfine
            jq
            shellcheck
            statix
            zizmor
          ];
        };
      });
    };
}
