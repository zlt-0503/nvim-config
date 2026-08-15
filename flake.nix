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
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      testHome = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          self.homeManagerModules.default
          {
            home = {
              username = "nvim-test";
              homeDirectory = "/home/nvim-test";
              stateVersion = "26.05";
            };
            sorasuka.neovim.enable = true;
          }
        ];
      };
    in
    {
      homeManagerModules.default = import ./nix/home-manager.nix;
      checks.${system}.home-manager = testHome.activationPackage;
    };
}
