{ config, pkgs, ... }:

let
  enzuru-emacs = (pkgs.emacsPackagesFor pkgs.emacs-git-pgtk).emacsWithPackages (epkgs: with pkgs; [
    clang-tools
    elixir-ls
    fish-lsp
    gopls
    haskell-language-server
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
    claude-code-acp

    # Languages
    elixir
    ghc
    go
    guile
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
    stack

    # Dev utilities
    appstream
    b4
    curl
    gdb
    git
    git-lfs
    jq
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
    checkov
    terraform

    # Monitoring
    btop
    htop
    glances
  ];
}
