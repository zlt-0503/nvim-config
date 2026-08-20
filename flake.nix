{
  description = "Sorasuka's Neovim configuration and Home Manager module";

  inputs = {
    nixpkgs.url = "git+https://github.com/NixOS/nixpkgs?ref=nixos-26.05&shallow=1";

    home-manager = {
      url = "git+https://github.com/nix-community/home-manager?ref=release-26.05&shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      mkHome =
        {
          system,
          username,
          homeDirectory ? if nixpkgs.lib.hasSuffix "-darwin" system then "/Users/${username}" else "/home/${username}",
          source ? null,
        }:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            self.homeManagerModules.default
            {
              home = {
                inherit username homeDirectory;
                stateVersion = "26.05";
              };
              programs.home-manager.enable = true;
              sorasuka.neovim = {
                enable = true;
                inherit source;
              };
            }
          ];
        };
      mkTestHome =
        system:
        mkHome {
          inherit system;
          username = "nvim-test";
        };
      mkInstaller =
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        pkgs.writeShellApplication {
          name = "install-nvim-home";
          runtimeInputs = [
            pkgs.coreutils
            pkgs.nix
          ];
          text = ''
            dry_run=false

            if [[ $# -gt 1 ]]; then
              printf 'Usage: nix run .#install -- [--dry-run]\n' >&2
              exit 2
            elif [[ $# -eq 1 ]]; then
              case "$1" in
                --dry-run) dry_run=true ;;
                -h|--help)
                  printf 'Usage: nix run .#install -- [--dry-run]\n'
                  exit 0
                  ;;
                *)
                  printf 'Usage: nix run .#install -- [--dry-run]\n' >&2
                  exit 2
                  ;;
              esac
            fi

            target_user=$(id -un)
            target_home=$HOME
            flake_ref=${nixpkgs.lib.escapeShellArg (toString self)}
            target_system=${nixpkgs.lib.escapeShellArg system}
            activation_expr='
            let
              flakeRef = builtins.getEnv "NVIM_HOME_FLAKE_REF";
              system = builtins.getEnv "NVIM_HOME_SYSTEM";
              username = builtins.getEnv "NVIM_HOME_USERNAME";
              homeDirectory = builtins.getEnv "NVIM_HOME_DIRECTORY";
              flake = builtins.getFlake flakeRef;
            in
            (flake.lib.mkHome {
              inherit system username homeDirectory;
            }).activationPackage
            '

            printf 'Target Home Manager user: %s (%s)\n' "$target_user" "$target_home"
            printf 'Target Nix system: %s\n' "$target_system"
            printf 'Building Home Manager activation package...\n'

            activation_path=$(
              NVIM_HOME_FLAKE_REF="$flake_ref" \
              NVIM_HOME_SYSTEM="$target_system" \
              NVIM_HOME_USERNAME="$target_user" \
              NVIM_HOME_DIRECTORY="$target_home" \
              nix --extra-experimental-features 'nix-command flakes' build \
                --impure \
                --expr "$activation_expr" \
                --no-link \
                --print-out-paths
            )

            if [[ -z "$activation_path" || ! -x "$activation_path/activate" ]]; then
              printf 'Invalid activation package path: %s\n' "$activation_path" >&2
              exit 1
            fi

            if $dry_run; then
              printf 'Dry run complete; the configuration builds and no home files were changed.\n'
              exit 0
            fi

            exec "$activation_path/activate"
          '';
        };
    in
    {
      homeManagerModules.default = import ./nix/home-manager.nix;
      lib.mkHome = mkHome;

      apps = forAllSystems (
        system:
        let
          installer = mkInstaller system;
          app = {
            type = "app";
            program = "${installer}/bin/install-nvim-home";
            meta.description = "Install the Neovim Home Manager configuration for the current user";
          };
        in
        {
          default = app;
          install = app;
        }
      );

      checks = forAllSystems (system: {
        home-manager = (mkTestHome system).activationPackage;
      });
    };
}
