# Oblibeny BOINC Platform

[![RSR Level](https://img.shields.io/badge/RSR-Bronze-cd7f32)](RSR_COMPLIANCE.md)
[![License](https://img.shields.io/badge/license-MIT%20%2B%20Palimpsest--0.8-blue)](LICENSE.txt)
[![TPCF](https://img.shields.io/badge/TPCF-Perimeter%203-green)](CONTRIBUTING.md#tpcf)
[![Security](https://img.shields.io/badge/security-RFC%209116-success)](.well-known/security.txt)

> **The first programming language developed with the cooperation of a global supercomputer**

Oblibeny is a revolutionary programming language that uses BOINC (Berkeley Open Infrastructure for Network Computing) to crowd-source formal verification of language properties through distributed computation.

## RSR Compliance: Bronze Level ✅

This project adheres to the [Rhodium Standard Repository (RSR)](RSR_COMPLIANCE.md) framework:
- **Score**: 89/110 (81%)
- **Level**: Bronze (certified)
- **TPCF Perimeter**: 3 (Community Sandbox)
- **Test Coverage**: Infrastructure ready (tests TODO)

See [RSR_COMPLIANCE.md](RSR_COMPLIANCE.md) for detailed compliance report.

## Vision

Oblibeny combines:

- 🔐 **Security by Design**: Two-phase compilation ensures deployment-time code is provably terminating and resource-bounded
- 🤖 **First-Class AI**: AI effects are typed, tracked, and verified at compile-time
- ✅ **Distributed Verification**: BOINC-powered crowd-sourced formal verification
- 🌍 **Sustainability-Focused**: Explicit resource tracking for energy, carbon, and computational costs
- 📐 **Formally Verified**: Properties proven through property-based testing and formal methods

## The Two-Phase Philosophy

```
┌─────────────────────┐         ┌─────────────────────┐
│  COMPILE-TIME       │         │  DEPLOYMENT-TIME    │
│  (Turing-Complete)  │  ════>  │  (Turing-Incomplete)│
│                     │         │                     │
│  • AI Integration   │         │  • Provably Safe    │
│  • Code Generation  │         │  • Resource-Bounded │
│  • Optimization     │         │  • No Halting Issue │
│  • Metaprogramming  │         │  • Edge-Ready       │
└─────────────────────┘         └─────────────────────┘
```

## Quick Start

### Using Just (Task Runner - Recommended)

```bash
# Show all available commands
just

# Validate RSR compliance
just validate

# Build all components
just build

# Run tests
just test

# Check RSR compliance status
just rsr-status

# Deploy locally
just deploy-local
```

### Using Nix (Reproducible Builds)

```bash
# Enter development environment
nix develop

# Build all components
nix build .#default

# Build specific components
nix build .#oblibeny-parser
nix build .#oblibeny-coordinator
nix build .#oblibeny-proofs
```

### Using Docker/Podman

```bash
cd deployment/podman
podman-compose up -d
```

This starts:
- ArangoDB database (port 8529)
- Elixir coordinator (port 4000)
- BOINC server (ports 80/443)
- Prometheus (port 9090)
- Grafana (port 3000)

### Manual Build

#### Rust Parser

```bash
cd rust-parser
cargo build --release
./target/release/oblibeny --help
```

#### Elixir Coordinator

```bash
cd elixir-coordinator
mix deps.get
mix compile
iex -S mix
```

#### Lean 4 Proofs

```bash
cd lean-proofs
lake build
```

## Architecture

### Components

1. **Rust Parser** (`rust-parser/`)
   - Parses Oblibeny source code
   - Phase separation analysis
   - Resource bounds checking
   - Termination verification

2. **Elixir Coordinator** (`elixir-coordinator/`)
   - OTP-based distributed coordination
   - BOINC work unit generation
   - Result validation with quorum consensus
   - Proof progress tracking

3. **Lean 4 Proofs** (`lean-proofs/`)
   - Formal verification of 7 key properties
   - Machine-checked proofs
   - Theorem library

4. **ArangoDB** (Database)
   - Multi-model storage (documents + graphs)
   - Work units, results, proofs
   - Proof dependency graphs

5. **BOINC Integration** (`boinc-app/`)
   - Validator (Ada)
   - Work generator
   - Result assimilator

## The 7 Properties

1. **Phase Separation Soundness** - No compile-time constructs in deployment code
2. **Deployment Termination** - All deploy-time code provably halts
3. **Resource Bounds Enforcement** - Never exceed declared budgets
4. **Capability System Soundness** - I/O only within capability scope
5. **Obfuscation Semantic Preservation** - Code morphing preserves semantics
6. **Call Graph Acyclicity** - No recursion in deployment
7. **Memory Safety** - All accesses within bounds

## Example Program

```lisp
(program temperature-monitor
  (resource-budget
    (time-ms 120000)
    (memory-bytes 2048)
    (network-bytes 1024))

  (defcap temp-sensor (device) "Temperature sensor capability")
  (defcap network (device) "Network send capability")

  (defun-deploy read-and-send (sensor-cap network-cap) : void
    (let ((readings (array int32 10)))
      (bounded-for i 0 10
        (let ((temp (with-capability sensor-cap
                      (sensor-read sensor-cap))))
          (array-set readings i temp)
          (sleep-ms 1000)))

      (with-capability network-cap
        (network-send network-cap readings)))))
```

## BOINC Volunteer Instructions

Want to help verify Oblibeny? Join our BOINC project:

1. Download the [BOINC client](https://boinc.berkeley.edu/download.php)
2. Add project URL: `http://oblibeny.boinc.project` (when deployed)
3. Your computer will automatically download and verify test programs

Your contribution helps:
- Test millions of program variants
- Find edge cases and counterexamples
- Build confidence in language properties
- Advance the state of verified programming languages

## Development

### Project Structure

```
oblibeny-boinc/
├── rust-parser/           # Rust parser & analyzer
├── elixir-coordinator/    # Elixir/OTP coordination
├── lean-proofs/           # Lean 4 formal proofs
├── boinc-app/             # BOINC integration
├── deployment/            # Docker/Podman/Nix configs
├── grammar/               # Language grammar & semantics
├── examples/              # Example programs
├── docs/                  # Documentation
└── flake.nix              # Nix build configuration
```

### Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## Documentation

- [Architecture Overview](docs/architecture/README.md)
- [Language Specification](grammar/oblibeny-semantics.md)
- [Deployment Guide](docs/deployment/README.md)
- [API Documentation](docs/api/README.md)
- [Task Handover Docs](02_TASK_RUST_PARSER.md)

## Monitoring

- **Coordinator Metrics**: http://localhost:4000/metrics
- **Prometheus**: http://localhost:9090
- **Grafana**: http://localhost:3000 (admin/admin)
- **ArangoDB UI**: http://localhost:8529

## Performance Targets

- **Parser**: < 100ms for 1000-line programs
- **Work Generation**: 1000 units/second
- **Result Validation**: 500 results/second
- **BOINC Server**: 10,000 concurrent volunteers

## License

GPL-3.0-or-later

## Citations

If you use Oblibeny in research, please cite:

```bibtex
@software{oblibeny2024,
  title={Oblibeny: Distributed Verification via BOINC},
  author={Oblibeny Project Contributors},
  year={2024},
  url={https://github.com/oblibeny/boinc}
}
```

## Acknowledgments

Built with:
- BOINC (Berkeley)
- Rust, Elixir/OTP, Lean 4
- ArangoDB, Nix, Podman

## Contact

- Project: [oblibeny.org](https://oblibeny.org)
- BOINC: [boinc.oblibeny.org](https://boinc.oblibeny.org)
- Issues: [GitHub Issues](https://github.com/oblibeny/boinc/issues)

---

**Status**: Active Development (v0.6.0)

*Empowering global collaboration for verified, safe programming languages*
