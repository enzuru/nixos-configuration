{ config, pkgs, ... }:

# Emacs ships tree-sitter support but no grammars, and it will not build them on
# demand. The list below covers the modes that ~/.emacs.d/init.el loads, because
# that configuration sets treesit-enabled-modes to t and needs every grammar.
let
  emacsWithGrammars = pkgs.emacs-git-pgtk.pkgs.withPackages (epkgs: [
    (epkgs.treesit-grammars.with-grammars (g: with g; [
      # Languages
      tree-sitter-bash
      tree-sitter-c
      tree-sitter-clojure
      tree-sitter-commonlisp
      tree-sitter-cpp
      tree-sitter-elisp
      tree-sitter-elixir
      tree-sitter-erlang
      tree-sitter-fish
      tree-sitter-gdscript
      tree-sitter-gherkin
      tree-sitter-go
      tree-sitter-groovy
      tree-sitter-haskell
      tree-sitter-java
      tree-sitter-javascript
      tree-sitter-kotlin
      tree-sitter-nix
      tree-sitter-objc
      tree-sitter-python
      tree-sitter-ruby
      tree-sitter-rust
      tree-sitter-scheme
      tree-sitter-swift
      tree-sitter-typescript
      tree-sitter-vala

      # Templates and markup
      tree-sitter-css
      tree-sitter-eex
      tree-sitter-embedded-template
      tree-sitter-heex
      tree-sitter-html
      tree-sitter-markdown
      tree-sitter-markdown-inline
      tree-sitter-org
      tree-sitter-scss
      tree-sitter-tsx
      tree-sitter-twig
      tree-sitter-vue

      # Data and configuration
      tree-sitter-dockerfile
      tree-sitter-godot-resource
      tree-sitter-gomod
      tree-sitter-gowork
      tree-sitter-hcl
      tree-sitter-json
      tree-sitter-sql
      tree-sitter-toml
      tree-sitter-yaml

      # Build and version control files
      tree-sitter-git-config
      tree-sitter-git-rebase
      tree-sitter-gitattributes
      tree-sitter-gitcommit
      tree-sitter-gitignore
      tree-sitter-make

      # Grammars that the modes above embed in other buffers
      tree-sitter-jsdoc
      tree-sitter-regex
    ]))
  ]);
in
{
  documentation.dev.enable = true;

  services.locate.enable = true;
  services.locate.interval = "minutely";

  users.users.enzuru.packages = with pkgs; [
    # Editor
    emacsWithGrammars

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
