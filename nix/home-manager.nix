{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sorasuka.neovim;

  bundledConfig = lib.fileset.toSource {
    root = ../.;
    fileset = lib.fileset.unions [
      ../after
      ../autoload
      ../ftdetect
      ../lua
      ../my_snippets
      ../plugin
      ../resources
      ../spell
      ../viml_conf
      ../ginit.vim
      ../init.lua
      ../lazy-lock.json
    ];
  };

  configEntries = [
    "after"
    "autoload"
    "ftdetect"
    "ginit.vim"
    "lazy-lock.json"
    "lua"
    "my_snippets"
    "plugin"
    "resources"
    "spell"
    "viml_conf"
  ];

  sourceFor =
    relativePath:
    if cfg.source == null then
      "${bundledConfig}/${relativePath}"
    else
      config.lib.file.mkOutOfStoreSymlink "${cfg.source}/${relativePath}";

  xdgConfigFiles = builtins.listToAttrs (
    map (relativePath: {
      name = "nvim/${relativePath}";
      value.source = sourceFor relativePath;
    }) configEntries
  );

  corePackages = with pkgs; [
    fd
    gcc
    gdb
    git
    gnumake
    ripgrep
    stylua
    tmux
    trash-cli
    tree-sitter
    universal-ctags
    yazi
  ] ++ lib.optionals pkgs.stdenv.isLinux [ wl-clipboard ];

  languageServers = with pkgs; [
    bash-language-server
    clang-tools
    gopls
    lua-language-server
    ocamlPackages.ocaml-lsp
    rust-analyzer
    vim-language-server
  ];

  writingTools = with pkgs; [
    ltex-ls-plus
    pandoc
  ];
in
{
  options.sorasuka.neovim = {
    enable = lib.mkEnableOption "Sorasuka's Neovim configuration";

    source = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "/home/user/.config/dotfiles/config/nvim";
      description = ''
        Optional absolute checkout path used as an out-of-store symlink. Leave
        null to deploy an immutable copy of this repository from the Nix store.
      '';
    };

    languageServers = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install the language servers enabled by lua/config/lsp.lua.";
    };

    writingTools = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Install LTeX LS and Pandoc; TeX itself remains system-managed.";
    };

    commonLisp = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Install SBCL and enable the optional Vlime workflow.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      withNodeJs = false;
      withPython3 = true;
      extraPython3Packages = pythonPackages: [ pythonPackages.pynvim ];

      plugins = [ pkgs.vimPlugins.lazy-nvim ];
      # Home Manager owns the generated init.lua so it can prepend provider and
      # package setup. The remaining config entries are linked below.
      initLua = builtins.readFile ../init.lua;
      extraPackages =
        corePackages
        ++ lib.optionals cfg.languageServers languageServers
        ++ lib.optionals cfg.writingTools writingTools
        ++ lib.optional cfg.commonLisp pkgs.sbcl;
    };

    xdg.configFile = xdgConfigFiles;
  };
}
