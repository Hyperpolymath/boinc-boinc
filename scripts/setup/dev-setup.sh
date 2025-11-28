#!/usr/bin/env bash
set -euo pipefail

# Oblibeny BOINC Development Environment Setup

echo "==================================="
echo "Oblibeny BOINC Development Setup"
echo "==================================="
echo ""

# Detect OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="mac"
else
    echo "Error: Unsupported OS: $OSTYPE"
    exit 1
fi

echo "Detected OS: $OS"
echo ""

# Check for Nix
if command -v nix >/dev/null 2>&1; then
    echo "✓ Nix detected"
    echo ""
    echo "Recommended: Use Nix for development"
    echo "  nix develop           # Enter dev environment"
    echo "  nix build .#default   # Build all components"
    echo ""
    read -p "Use Nix? [Y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        exec nix develop
    fi
fi

echo "Setting up dependencies manually..."
echo ""

# Rust
if ! command -v cargo >/dev/null 2>&1; then
    echo "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
else
    echo "✓ Rust installed: $(rustc --version)"
fi

# Elixir
if ! command -v elixir >/dev/null 2>&1; then
    echo "Installing Elixir..."
    if [[ "$OS" == "linux" ]]; then
        echo "Please install Elixir manually for your distribution"
        echo "  Debian/Ubuntu: sudo apt-get install elixir"
        echo "  Fedora: sudo dnf install elixir"
    else
        echo "Installing via Homebrew..."
        brew install elixir
    fi
else
    echo "✓ Elixir installed: $(elixir --version | head -n1)"
fi

# Lean 4
if ! command -v lean >/dev/null 2>&1; then
    echo "Installing Lean 4..."
    curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh -s -- -y
else
    echo "✓ Lean 4 installed: $(lean --version)"
fi

# Build Rust parser
echo ""
echo "Building Rust parser..."
cd rust-parser
cargo build
cd ..

# Setup Elixir coordinator
echo ""
echo "Setting up Elixir coordinator..."
cd elixir-coordinator
mix local.hex --force
mix local.rebar --force
mix deps.get
cd ..

# Build Lean proofs
echo ""
echo "Building Lean proofs..."
cd lean-proofs
lake build || echo "Lean build failed (expected if dependencies missing)"
cd ..

echo ""
echo "==================================="
echo "Development Setup Complete!"
echo "==================================="
echo ""
echo "Next steps:"
echo "  cd rust-parser && cargo test"
echo "  cd elixir-coordinator && iex -S mix"
echo "  cd lean-proofs && lake build"
echo ""
