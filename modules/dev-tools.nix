{ config, pkgs, ... }:

{
  documentation.dev.enable = true;

  services.locate.enable = true;
  services.locate.interval = "minutely";

  users.users.enzuru.packages = with pkgs; [
    # Editor
    emacs-git-pgtk

    # AI
    claude-code
    claude-agent-acp

    # Languages
    clojure
    elixir
    ghc
    go
    guile
    nodejs
    ruby
    rustc
    sbcl

    # Language servers
    clang-tools
    clojure-lsp
    elixir-ls
    fish-lsp
    gopls
    haskell-language-server
    pyright
    rust-analyzer
    solargraph
    typescript-language-server

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
