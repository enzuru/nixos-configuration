{ config, pkgs, ... }:

let
  enzuru-emacs = (pkgs.emacsPackagesFor pkgs.emacs-git-pgtk).emacsWithPackages (epkgs: with pkgs; [
    clang-tools
    clojure-lsp
    elixir-ls
    fish-lsp
    gopls
    pyright
    rust-analyzer
    solargraph
    typescript-language-server
  ]);
in

{
  documentation.dev.enable = true;

  services.locate.enable = true;
  services.locate.interval = "minutely";

  users.users.enzuru.packages = with pkgs; [
    # Editor
    enzuru-emacs

    # AI
    claude-code
    claude-agent-acp

    # Languages
    clojure
    elixir
    ghc
    go
    guile
    haskell-language-server
    nodejs
    ruby
    rustc
    sbcl

    # Build tools
    autoconf
    blueprint-compiler
    clang
    flatpak-builder
    gnumake
    hugo
    leiningen
    stack

    # Dev utilities
    appstream
    b4
    cachix
    curl
    darcs
    gdb
    git
    git-lfs
    jq
    libghostty-vt
    mc
    mg
    nix-prefetch-github
    nixpkgs-review
    openssl
    tree-sitter
    tmux
    wget

    # Infrastructure
    awscli
    # checkov
    terraform

    # Monitoring
    btop
    htop
    glances
  ];
}
