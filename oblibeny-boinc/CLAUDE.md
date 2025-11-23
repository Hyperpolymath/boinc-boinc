# CLAUDE.md

This document provides context and guidance for AI assistants (like Claude) working with the Oblibeny BOINC Platform codebase.

## Project Overview

The **Oblibeny BOINC Platform** is a distributed verification infrastructure for the Oblibeny programming language, leveraging BOINC (Berkeley Open Infrastructure for Network Computing) to harness volunteer computing power for testing, formal verification, and benchmarking.

### What is Oblibeny?

Oblibeny is a **security-first programming language** targeting IoT, embedded systems, and edge computing with these key innovations:

1. **Two-Phase Compilation**
   - **Phase 1 (Development)**: Turing-complete, full expressivity
   - **Phase 2 (Deployment)**: Turing-incomplete, guaranteed termination
   - Enables powerful metaprogramming while ensuring safety in production

2. **Capability-Based I/O**
   - Fine-grained permissions system
   - Principle of least privilege by default
   - No ambient authority

3. **Static Resource Bounds**
   - Memory usage known at compile-time
   - CPU time limits enforced
   - Suitable for resource-constrained devices

4. **Semantic Obfuscation**
   - Code transformations that preserve semantics
   - Defense against reverse engineering
   - Optional feature for security-critical deployments

5. **Formal Verification**
   - Lean 4 proofs of correctness
   - Seven critical properties verified
   - Byzantine fault tolerance (2/3 quorum consensus)

### Why BOINC?

We use BOINC to:
- Test Oblibeny programs across **diverse platforms** (Linux, Windows, macOS, BSD, Android, iOS, RISC-V)
- Perform **differential testing** against reference implementations
- Run **fuzzing campaigns** to discover edge cases
- Benchmark **performance characteristics** across hardware
- Verify **formal properties** through distributed proof checking
- Build a **community** of volunteers who believe in politically autonomous software

### Project Goals

1. **Primary**: Create a self-hosted BOINC server for Oblibeny verification
2. **Secondary**: Achieve RSR Silver level compliance (currently Bronze)
3. **Tertiary**: Build a thriving open-source community
4. **Ultimate**: Enable trustless, distributed verification of safety-critical software

## Technology Stack

### Core Components

| Component | Technology | Purpose | Status |
|-----------|-----------|---------|--------|
| **Parser** | Rust | Parse Oblibeny syntax, generate AST | ✅ Complete |
| **Analyzer** | Rust | Semantic analysis, type checking | ✅ Complete |
| **Coordinator** | Elixir/OTP | Distributed task coordination | ✅ Complete |
| **Formal Proofs** | Lean 4 | Verify language properties | ⚠️ Scaffolding |
| **Database** | ArangoDB | Multi-model storage (graph + document) | ✅ Complete |
| **Build System** | Nix | Reproducible builds | ✅ Complete |
| **Task Runner** | just | Development workflow | ✅ Complete |
| **Containerization** | Podman/Docker | Local deployment | ✅ Complete |
| **CI/CD** | GitLab CI | Automated testing | ✅ Complete |
| **Configuration** | Nickel | Type-safe config management | ⏳ TODO |
| **Dashboard** | Phoenix LiveView | Real-time monitoring | ⏳ TODO |
| **Work Validation** | Ada (planned) | Safety-critical quorum logic | ⏳ TODO |

### Language Distribution

- **Rust** (40%): Performance-critical paths (parser, analyzer)
- **Elixir** (30%): Distributed coordination, API server, real-time features
- **Lean 4** (15%): Formal verification, proofs
- **Ada** (10%, planned): Safety-critical validation logic
- **Nickel** (5%): Type-safe configuration

### Why These Technologies?

**Rust**: Memory safety without garbage collection, ideal for parsers and analyzers.

**Elixir/OTP**: Built for distributed systems, fault tolerance via supervision trees, perfect for BOINC coordinator.

**Lean 4**: Cutting-edge proof assistant with dependent types, supports our verification goals.

**Ada**: Proven track record in safety-critical systems (aerospace, defense), ideal for work validation.

**Nickel**: Type-safe configuration language, prevents configuration errors.

**ArangoDB**: Multi-model database (graph + document), efficient for both work queues and relationship modeling.

**Nix**: Reproducible builds across platforms, critical for scientific computing.

## Project Structure

```
oblibeny-boinc/
├── rust-parser/                 # Rust parser and analyzer
│   ├── src/
│   │   ├── main.rs              # CLI entry point
│   │   ├── parser/              # PEG parser (pest-based)
│   │   ├── analyzer/            # Semantic analysis
│   │   ├── ast/                 # AST definitions
│   │   └── errors/              # Error handling
│   ├── Cargo.toml               # Rust dependencies
│   └── tests/                   # Unit tests (TODO)
│
├── elixir-coordinator/          # Elixir/OTP coordinator
│   ├── lib/
│   │   ├── coordinator.ex       # Main application
│   │   ├── work_queue.ex        # Work unit management
│   │   ├── validator.ex         # Result validation
│   │   └── api/                 # HTTP API
│   ├── mix.exs                  # Elixir dependencies
│   └── test/                    # Tests (TODO)
│
├── lean-proofs/                 # Lean 4 formal proofs
│   ├── Oblibeny/
│   │   ├── Syntax.lean          # Syntax formalization
│   │   ├── Semantics.lean       # Operational semantics
│   │   ├── Properties.lean      # Properties to prove
│   │   └── Proofs/              # Proof modules (incomplete)
│   └── lakefile.lean            # Lean build config
│
├── phoenix-dashboard/           # Phoenix LiveView dashboard (planned)
│   ├── lib/
│   │   ├── dashboard_web/       # Web interface
│   │   └── dashboard/           # Business logic
│   └── mix.exs
│
├── boinc-app/                   # BOINC application wrapper
│   ├── work_generator/          # Generate work units
│   ├── validator/               # Validate results (Ada planned)
│   └── assimilator/             # Process validated results
│
├── grammar/                     # Grammar files
│   ├── oblibeny-grammar.ebnf    # EBNF grammar (586 lines)
│   └── oblibeny-semantics.md    # Formal semantics (678 lines)
│
├── examples/                    # Example Oblibeny programs
│   ├── led-blinker.obl          # IoT example
│   ├── temperature-monitor.obl  # Sensor example
│   └── secure-voting.obl        # Security example
│
├── deployment/                  # Deployment configurations
│   ├── podman/                  # Podman Compose
│   ├── nix/                     # Nix expressions
│   └── saltstack/               # Multi-server orchestration (planned)
│
├── docs/                        # Additional documentation
│   ├── architecture/            # Architecture diagrams
│   ├── tutorials/               # User guides
│   └── api/                     # API documentation
│
├── scripts/                     # Utility scripts
│   ├── setup/                   # Development setup
│   ├── deploy/                  # Deployment scripts
│   └── testing/                 # Test harnesses
│
├── tests/                       # Integration tests (TODO)
│
├── .well-known/                 # Machine-readable metadata
│   ├── security.txt             # RFC 9116 security contact
│   ├── ai.txt                   # AI training policies
│   └── humans.txt               # Human-readable credits
│
├── flake.nix                    # Nix flake for reproducible builds
├── justfile                     # Task runner (30+ recipes)
├── .gitlab-ci.yml               # CI/CD pipeline
├── RSR_COMPLIANCE.md            # RSR Framework compliance report
├── SECURITY.md                  # Security policies
├── CODE_OF_CONDUCT.md           # Contributor Covenant + CCCP
├── CONTRIBUTING.md              # Contribution guidelines
├── MAINTAINERS.md               # Team structure (TPCF)
├── CHANGELOG.md                 # Version history
├── LICENSE.txt                  # Dual MIT + Palimpsest-0.8
└── README.md                    # Project overview
```

## Development Environment Setup

### Prerequisites

#### System Dependencies

**Linux (Debian/Ubuntu)**:
```bash
sudo apt-get update
sudo apt-get install -y \
  git curl build-essential pkg-config \
  libssl-dev \
  # Rust (install via rustup)
  # Elixir
  erlang elixir \
  # Nix
  # Lean 4 (install via elan)
```

**macOS**:
```bash
brew install git curl pkg-config openssl \
  rust elixir nix lean
```

**NixOS/Nix users**:
```bash
# Just use the flake!
nix develop
```

#### Language Toolchains

**Rust** (1.75+):
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup component add clippy rustfmt
cargo install cargo-watch cargo-audit
```

**Elixir** (1.15+):
```bash
# Install Erlang/OTP 26+ first
# Then install Elixir via your package manager
mix local.hex --force
mix local.rebar --force
```

**Lean 4**:
```bash
curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh
elan install leanprover/lean4:stable
```

**Nix** (2.18+):
```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
nix-env -iA nixpkgs.nixFlakes
```

**just** (task runner):
```bash
cargo install just
# or: brew install just
# or: nix-env -iA nixpkgs.just
```

### Quick Start

```bash
# Clone the repository
git clone https://github.com/oblibeny/boinc.git
cd boinc/oblibeny-boinc

# Option 1: Use Nix (recommended)
nix develop
just build

# Option 2: Manual setup
just dev-setup
just build

# Run validation
just validate

# Run all tests (when implemented)
just test

# Start local deployment
just deploy-local

# Check RSR compliance status
just rsr-status
```

## Common Development Tasks

### Building Components

```bash
# Build everything
just build

# Build individual components
just build-rust       # Rust parser
just build-elixir     # Elixir coordinator
just build-lean       # Lean proofs

# Clean builds
just clean
```

### Testing

```bash
# Run all tests (when implemented)
just test

# Test individual components
just test-rust        # Cargo tests + clippy
just test-elixir      # Mix tests
just test-lean        # Lean verification
```

### Code Quality

```bash
# Format code
just fmt              # All components
just fmt-rust         # Rust only
just fmt-elixir       # Elixir only

# Check formatting
just check-fmt

# Lint code
just lint             # All components
just lint-rust        # Clippy
just lint-elixir      # Credo

# Security audit
just audit            # All dependencies
just audit-rust       # cargo-audit
just audit-elixir     # mix audit
```

### Development Workflow

```bash
# Watch for changes and rebuild
just watch-rust       # cargo watch
just watch-elixir     # mix test.watch

# Run examples
just examples         # All examples
just example-parse    # Parse LED blinker
just example-analyze  # Analyze temperature monitor

# Generate documentation
just docs             # All docs
just docs-rust        # Cargo doc
just docs-elixir      # ExDoc
```

### Deployment

```bash
# Local deployment (Podman)
just deploy-local     # Start services
just deploy-stop      # Stop services

# Production deployment (requires setup)
just deploy-production

# CI/CD simulation
just ci               # validate + build + test + lint + audit
```

## Architecture

### Two-Phase Compilation Model

```
┌─────────────────────────────────────────────────────────────┐
│                   PHASE 1: DEVELOPMENT                      │
│                  (Turing-Complete)                          │
│                                                             │
│  ┌──────────┐      ┌──────────┐      ┌──────────┐         │
│  │  Source  │─────▶│  Parser  │─────▶│ Analyzer │         │
│  │   .obl   │      │  (Rust)  │      │  (Rust)  │         │
│  └──────────┘      └──────────┘      └──────────┘         │
│                                              │              │
│                                              ▼              │
│                                      ┌───────────────┐      │
│                                      │ Metaprogramming│     │
│                                      │   Expansion   │     │
│                                      └───────┬───────┘      │
│                                              │              │
│                                              ▼              │
│                                      ┌───────────────┐      │
│                                      │ Optimization  │     │
│                                      └───────┬───────┘      │
└──────────────────────────────────────────────┼──────────────┘
                                               │
                                               ▼
┌─────────────────────────────────────────────────────────────┐
│                   PHASE 2: DEPLOYMENT                       │
│                 (Turing-Incomplete)                         │
│                                                             │
│                       ┌──────────┐                          │
│                       │ Stripped │                          │
│                       │  Deploy  │                          │
│                       │   Code   │                          │
│                       └─────┬────┘                          │
│                             │                               │
│          ┌──────────────────┼──────────────────┐           │
│          ▼                  ▼                  ▼           │
│    ┌──────────┐      ┌──────────┐      ┌──────────┐       │
│    │ Resource │      │   I/O    │      │Termination│      │
│    │  Bounds  │      │Capability│      │Guaranteed │      │
│    │  Check   │      │  Check   │      │   Check   │      │
│    └──────────┘      └──────────┘      └──────────┘       │
│                                                             │
│                       ┌──────────┐                          │
│                       │  Target  │                          │
│                       │ Platform │                          │
│                       │  Binary  │                          │
│                       └──────────┘                          │
└─────────────────────────────────────────────────────────────┘
```

### BOINC Integration Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    BOINC SERVER (Self-Hosted)               │
│                                                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │Work Generator│  │  Validator   │  │ Assimilator  │     │
│  │  (Elixir)   │  │    (Ada)     │  │  (Elixir)    │     │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘     │
│         │                 │                 │              │
│         │                 │                 │              │
│         ▼                 ▼                 ▼              │
│  ┌──────────────────────────────────────────────────┐      │
│  │            ArangoDB Database                     │      │
│  │  (Work Units, Results, Users, Hosts)            │      │
│  └──────────────────────────────────────────────────┘      │
│                                                             │
│  ┌──────────────────────────────────────────────────┐      │
│  │     Phoenix LiveView Dashboard                   │      │
│  │  (Real-time monitoring, statistics)             │      │
│  └──────────────────────────────────────────────────┘      │
└─────────────────────────────────────────────────────────────┘
                             │
                             │ HTTPS
                             ▼
┌─────────────────────────────────────────────────────────────┐
│                  VOLUNTEER CLIENTS                          │
│                                                             │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐       │
│  │ Linux   │  │ Windows │  │  macOS  │  │ Android │       │
│  │  x86_64 │  │  x86_64 │  │  ARM64  │  │  ARM    │       │
│  └─────────┘  └─────────┘  └─────────┘  └─────────┘       │
│                                                             │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐       │
│  │   iOS   │  │ RISC-V  │  │  BSD    │  │   IoT   │       │
│  │  ARM64  │  │         │  │         │  │  Edge   │       │
│  └─────────┘  └─────────┘  └─────────┘  └─────────┘       │
└─────────────────────────────────────────────────────────────┘
```

### Distributed Validation Flow

```
1. Work Generation
   ─────────────▶
   Coordinator generates test cases from grammar
   │
   ├─ Fuzzing: Random valid programs
   ├─ Differential: Compare with reference impl
   ├─ Benchmarking: Performance tests
   ├─ Property: Verify specific properties
   └─ Platform: Cross-platform compatibility

2. Work Distribution (Redundancy: 3+ instances)
   ─────────────▶
   Same work sent to multiple volunteers
   │
   ├─ Platform diversity (Linux, Windows, macOS, etc.)
   ├─ Hardware diversity (x86, ARM, RISC-V, etc.)
   └─ Geographic diversity (global distribution)

3. Computation
   ─────────────▶
   Volunteers run Oblibeny programs in sandbox
   │
   ├─ VirtualBox VM (strong isolation)
   ├─ Docker/Podman container (lightweight)
   ├─ Flatpak (sandboxed environment)
   └─ Native (trusted volunteers only)

4. Result Validation (Byzantine Fault Tolerance)
   ─────────────▶
   Ada validator compares results via 2/3 quorum
   │
   ├─ Exact match: Result accepted
   ├─ 2/3 agreement: Majority wins
   ├─ No consensus: Work reissued
   └─ Malicious detection: Volunteer flagged

5. Assimilation
   ─────────────▶
   Validated results stored in database
   │
   ├─ Performance metrics collected
   ├─ Platform compatibility recorded
   ├─ Property verification confirmed
   └─ Anomalies flagged for investigation
```

## Seven Critical Properties

The Oblibeny language must satisfy these formally verified properties:

### 1. Phase Separation Soundness
**Property**: Code marked `deploy` cannot use `comptime` features.

**Lean Proof Status**: ⚠️ Scaffold only (uses `sorry`)

**Why It Matters**: Ensures deployment code is Turing-incomplete.

**Testing Strategy**: Parse all example programs, verify `deploy` blocks contain no `comptime` constructs.

### 2. Deployment Termination
**Property**: All `deploy` code terminates in finite time.

**Lean Proof Status**: ⚠️ Scaffold only (uses `sorry`)

**Why It Matters**: No infinite loops in production.

**Testing Strategy**: Run all deployment code with timeout, verify termination within resource bounds.

### 3. Resource Bounds Enforcement
**Property**: Memory/CPU usage respects declared bounds.

**Lean Proof Status**: ⚠️ Scaffold only (uses `sorry`)

**Why It Matters**: Prevents resource exhaustion attacks.

**Testing Strategy**: Instrument runtime, measure actual resource usage vs. declared bounds.

### 4. Capability System Soundness
**Property**: I/O operations require explicit capabilities.

**Lean Proof Status**: ⚠️ Not yet formalized

**Why It Matters**: Enforces principle of least privilege.

**Testing Strategy**: Attempt I/O without capabilities, verify rejection.

### 5. Obfuscation Semantic Preservation
**Property**: Obfuscated code behaves identically to original.

**Lean Proof Status**: ⚠️ Not yet formalized

**Why It Matters**: Security transforms must not introduce bugs.

**Testing Strategy**: Compare outputs of original vs. obfuscated on same inputs.

### 6. Call Graph Acyclicity (Deployment)
**Property**: No recursive calls in `deploy` code.

**Lean Proof Status**: ⚠️ Not yet formalized

**Why It Matters**: Another guarantee of termination.

**Testing Strategy**: Build call graph, verify it's a DAG.

### 7. Memory Safety
**Property**: No buffer overflows, use-after-free, or null dereferences.

**Lean Proof Status**: ⚠️ Not yet formalized

**Why It Matters**: Prevents most common vulnerabilities.

**Testing Strategy**: Compile to safe backend (Rust, verified C), use sanitizers.

## RSR Framework Compliance

**Current Level**: Bronze ✅ (89/110, 81%)

**Target Level**: Silver (Q1 2025), Gold (Q3 2025)

### Bronze Requirements (ALL MET ✅)

- [x] 100+ lines of code (~5,000 LOC)
- [x] Zero unsafe dependencies
- [x] Type safety (Rust + Elixir + Lean)
- [x] Memory safety (Rust ownership)
- [x] Offline-first (no network required for core tools)
- [x] Complete documentation (README, SECURITY, CoC, etc.)
- [x] Build system (Nix + justfile + CI/CD)
- [x] Test infrastructure (ready, tests TODO)
- [x] TPCF perimeter assigned (Perimeter 3: Community Sandbox)
- [x] Dual licensing (MIT + Palimpsest-0.8)

### Path to Silver (Missing Items)

- [ ] **Testing**: 80%+ coverage, all tests passing (currently 0%)
- [ ] **Verification**: Complete properties 1-3 proofs (currently scaffolds)
- [ ] **Fuzzing**: Add cargo-fuzz, proptest
- [ ] **Static analysis**: Full clippy --deny warnings, credo --strict
- [ ] **SBOM**: Software Bill of Materials
- [ ] **Signed releases**: GPG signatures

## Licensing

This project uses **dual licensing**:

1. **MIT License**: Permissive, allows commercial use
2. **Palimpsest License v0.8**: Adds ethical constraints

**SPDX Identifier**: `MIT AND Palimpsest-0.8`

### Palimpsest License Principles

- **Reversibility**: All changes can be undone (48-hour window)
- **Attribution**: Credit those who came before
- **Emotional Safety**: No fear, only learning
- **Political Autonomy**: No platform lock-in
- **Offline-First**: Works without the cloud
- **Distributed Trust**: No single point of control

### Contribution Note

By contributing to this project, you agree to license your contributions under both MIT and Palimpsest-0.8. See `CONTRIBUTING.md` for details.

## Community & Governance

### TPCF (Three-Perimeter Community Framework)

**Perimeter 3**: Community Sandbox (current project status)
- Anyone can contribute via pull requests
- Changes reviewed by Perimeter 2

**Perimeter 2**: Trusted Contributors
- Demonstrated commitment (5+ accepted PRs)
- Can review others' PRs
- Limited commit access

**Perimeter 1**: Core Maintainers
- Architectural decisions
- Release management
- Security response

See `MAINTAINERS.md` for current team and promotion criteria.

### Code of Conduct

We follow the **Contributor Covenant** + **CCCP (Cybernetic Collective Care Protocol)**.

Key principles:
- Blameless post-mortems
- Anxiety reduction
- Experimentation encouraged
- Psychological safety paramount

Report violations to: `conduct@oblibeny.org`

## Security

### Reporting Vulnerabilities

**DO NOT** open public issues for security vulnerabilities.

**Contact**: `security@oblibeny.org`

**PGP Key**: https://oblibeny.org/.well-known/pgp-key.txt

**Response Timeline**:
- Critical: < 4 hours
- High: < 24 hours
- Medium: < 7 days
- Low: < 30 days

See `SECURITY.md` for full policy.

### Security Measures

- **Memory safety**: Rust eliminates entire classes of vulnerabilities
- **Input validation**: Multi-layer validation (parser, analyzer, runtime)
- **Capability system**: No ambient authority
- **Resource bounds**: Prevents DoS attacks
- **Byzantine fault tolerance**: 2/3 quorum prevents malicious results
- **Dependency auditing**: `cargo audit` and `mix audit` in CI

## Testing Strategy

### Current State

**Test Infrastructure**: ✅ Ready
**Test Coverage**: 0% (TODO)
**CI Integration**: ✅ Complete (runs on commit)

### Test Types Needed

#### 1. Unit Tests

**Rust** (`rust-parser/tests/`):
```bash
cd rust-parser
cargo test                    # Run tests
cargo test --coverage         # Generate coverage
```

**Elixir** (`elixir-coordinator/test/`):
```bash
cd elixir-coordinator
MIX_ENV=test mix test        # Run tests
mix test --cover             # Generate coverage
```

**Lean** (`lean-proofs/`):
```bash
cd lean-proofs
lake build                    # Verify proofs compile
# Tests pass when all `sorry` placeholders are replaced
```

#### 2. Integration Tests

**Cross-component** (`tests/integration/`):
- Parser → Analyzer pipeline
- Coordinator → Validator → Assimilator flow
- Full work unit lifecycle

#### 3. Property-Based Tests

**Rust** (proptest):
```rust
proptest! {
    #[test]
    fn parse_arbitrary_program(s in ".*") {
        // Parser should never panic
        let _ = parse(&s);
    }
}
```

**Elixir** (StreamData):
```elixir
property "work queue maintains FIFO order" do
  check all jobs <- list_of(work_unit()) do
    # Verify queue ordering
  end
end
```

#### 4. Fuzzing

**cargo-fuzz** (AFL, LibFuzzer):
```bash
cd rust-parser
cargo fuzz run parse_fuzz
```

**Grammar-based fuzzing**:
- Generate random valid Oblibeny programs
- Verify parser accepts them
- Verify analyzer doesn't crash

#### 5. Differential Testing

Compare Oblibeny behavior with:
- Reference interpreter (if written)
- Formal semantics (Lean 4)
- Other safe languages (Rust, Ada)

#### 6. Platform Testing (BOINC)

Test on:
- **Operating Systems**: Linux, Windows, macOS, BSD, Android, iOS
- **Architectures**: x86_64, ARM, ARM64, RISC-V
- **Environments**: Bare metal, VM, container, cloud, edge

### Test Automation

All tests run in CI/CD:

```yaml
# .gitlab-ci.yml
test:
  script:
    - just test           # All tests
    - just test-rust      # Rust tests
    - just test-elixir    # Elixir tests
    - just test-lean      # Lean verification
  coverage: '/\d+\.\d+%/'
```

## Contributing

### Getting Started

1. **Read the documentation**:
   - `README.md`: Project overview
   - `CONTRIBUTING.md`: Contribution guidelines
   - `CODE_OF_CONDUCT.md`: Community standards
   - `SECURITY.md`: Security policies
   - This file (`CLAUDE.md`): Developer guide

2. **Set up your environment**:
   ```bash
   git clone https://github.com/oblibeny/boinc.git
   cd boinc/oblibeny-boinc
   nix develop           # or: just dev-setup
   just build
   just test
   ```

3. **Find an issue**:
   - Check GitHub issues: https://github.com/oblibeny/boinc/issues
   - Look for `good-first-issue` label
   - Ask in discussions if unsure

4. **Make your changes**:
   - Create a branch: `git checkout -b feature/my-feature`
   - Write code following existing style
   - Add tests (this is critical!)
   - Update documentation if needed

5. **Submit a pull request**:
   - Run `just ci` locally first
   - Write clear commit messages
   - Reference related issues
   - Describe testing performed

### Code Style

**Rust**:
- Run `cargo fmt` before committing
- Run `cargo clippy -- -D warnings` (no warnings allowed)
- Follow Rust API guidelines

**Elixir**:
- Run `mix format` before committing
- Run `mix credo --strict` (address all issues)
- Follow Elixir style guide

**Lean**:
- Follow Lean 4 conventions
- Use descriptive theorem names
- Add comments explaining proof strategies

### Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
feat(parser): add support for pattern matching
fix(coordinator): prevent race in work queue
docs(readme): clarify build instructions
test(analyzer): add property tests for type checker
chore(deps): update Rust to 1.76
```

### PR Checklist

- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] `just ci` passes locally
- [ ] Commit messages follow convention
- [ ] No merge conflicts
- [ ] Linked to related issue(s)

## AI Assistant Guidance

When working with this codebase as an AI assistant:

### DO

1. **Search before creating**: Use `grep`, `find`, or IDE search to locate existing similar code
2. **Maintain architectural consistency**: Follow existing patterns (Rust for perf, Elixir for coordination)
3. **Write tests**: Every new feature needs tests (we're at 0%, let's fix that!)
4. **Update documentation**: If you change behavior, update docs
5. **Follow RSR principles**: Reversibility, attribution, emotional safety, etc.
6. **Ask for clarification**: If requirements are unclear, ask the user
7. **Consider all platforms**: Changes may affect Linux, Windows, macOS, etc.
8. **Prioritize safety**: This is a security-focused language; safety > convenience
9. **Think distributedly**: BOINC is inherently distributed; design for failure
10. **Verify formally**: When possible, back claims with Lean proofs

### DON'T

1. **Don't use `unsafe` in Rust**: Zero unsafe blocks in application code (policy)
2. **Don't skip tests**: We need to increase coverage, not keep it at 0%
3. **Don't break backward compatibility**: Existing Oblibeny programs should still parse
4. **Don't introduce dependencies carelessly**: Every dep is a security surface
5. **Don't assume single platform**: Test on multiple OSes if changing core logic
6. **Don't ignore clippy/credo**: Linter warnings are bugs waiting to happen
7. **Don't commit secrets**: Check `.env`, `credentials.json`, etc.
8. **Don't use `sorry` in Lean**: Proof scaffolds are TODO, not solutions
9. **Don't forget documentation**: Undocumented code is legacy code
10. **Don't violate Palimpsest principles**: Political autonomy matters

### Common Pitfalls

1. **Nix cache issues**: If builds fail, try `nix-collect-garbage -d`
2. **Elixir compilation**: Run `mix deps.get` after pulling
3. **Lean lake issues**: Delete `.lake` and rebuild
4. **Podman vs Docker**: Commands mostly identical, but networking differs
5. **Grammar updates**: If you change grammar, regenerate parser tests
6. **Platform-specific code**: Use conditional compilation (`#[cfg(target_os = "...")]`)

### Key Files to Know

- `rust-parser/src/parser/grammar.pest`: PEG grammar (auto-generated from EBNF)
- `elixir-coordinator/lib/coordinator.ex`: Main OTP application
- `lean-proofs/Oblibeny/Properties.lean`: Properties to prove
- `grammar/oblibeny-grammar.ebnf`: Canonical grammar (source of truth)
- `flake.nix`: Nix build configuration
- `justfile`: Development commands
- `.gitlab-ci.yml`: CI/CD pipeline
- `RSR_COMPLIANCE.md`: Compliance status

### Useful Commands

```bash
# Find all TODOs in the codebase
grep -r "TODO" --include="*.rs" --include="*.ex" --include="*.lean"

# Check for unsafe Rust code (should be none)
cd rust-parser && grep -r "unsafe" src/ || echo "✅ No unsafe blocks"

# Find all `sorry` placeholders in Lean proofs
cd lean-proofs && grep -r "sorry" . | wc -l

# See project statistics
tokei oblibeny-boinc/

# Generate dependency graph
cd rust-parser && cargo tree
cd elixir-coordinator && mix deps.tree

# Check security advisories
just audit
```

### When Implementing New Features

1. **Start with the grammar**: Is the syntax change needed? Update `oblibeny-grammar.ebnf`
2. **Update the parser**: Modify `rust-parser/src/parser/`
3. **Update the analyzer**: Modify `rust-parser/src/analyzer/`
4. **Formalize in Lean**: Add to `lean-proofs/Oblibeny/Syntax.lean` or `Semantics.lean`
5. **Prove properties**: Attempt proofs in `Properties.lean` (or leave as `sorry` with TODO)
6. **Write tests**: Add to `rust-parser/tests/` and `examples/`
7. **Update docs**: Modify README, CHANGELOG, relevant .md files
8. **Run CI**: `just ci` to ensure everything passes

### When Fixing Bugs

1. **Reproduce first**: Write a failing test
2. **Find root cause**: Use `cargo test -- --nocapture` for Rust, `IO.inspect` for Elixir
3. **Fix minimally**: Smallest change that fixes the issue
4. **Verify fix**: Ensure the test now passes
5. **Check for regressions**: Run full test suite
6. **Document**: Add comment explaining the fix if non-obvious

## Roadmap

### Immediate Priorities (Next 2 Weeks)

1. **Write tests**: Achieve 20%+ coverage
   - Rust parser unit tests
   - Elixir coordinator tests
   - Integration tests

2. **Complete Nickel configuration**:
   - Replace hardcoded config values
   - Type-safe BOINC server settings

3. **Build Phoenix dashboard**:
   - Real-time work queue monitoring
   - Volunteer statistics
   - Platform distribution charts

### Short-term (1-3 Months)

1. **Deploy BOINC server**:
   - Self-hosted instance
   - Work generator from grammar
   - Validator with 2/3 quorum

2. **Complete Property 1 proof** (Phase Separation):
   - Remove `sorry` placeholders
   - Verify in Lean 4

3. **Add fuzzing**:
   - Grammar-based test generation
   - cargo-fuzz integration

### Medium-term (3-6 Months)

1. **Achieve Silver RSR compliance**:
   - 80%+ test coverage
   - All linters passing
   - SBOM generated
   - Signed releases

2. **Complete Properties 2-3 proofs**:
   - Termination guarantee
   - Resource bounds

3. **Multi-platform testing**:
   - BOINC clients on Windows, macOS, Linux, BSD
   - Cross-compile to ARM, RISC-V

### Long-term (6-12 Months)

1. **Achieve Gold RSR compliance**:
   - All 7 properties proven
   - Security audit completed
   - Production deployment

2. **Community growth**:
   - 10+ regular contributors
   - 100+ volunteer BOINC clients

3. **Production use case**:
   - Real IoT application written in Oblibeny
   - Deployed to hardware

## Resources

### Official Links

- **Website**: https://oblibeny.org (planned)
- **GitLab**: https://gitlab.com/oblibeny/boinc (primary)
- **GitHub**: https://github.com/oblibeny/boinc (mirror)
- **Forum**: https://forum.oblibeny.org (planned)
- **Chat**: https://chat.oblibeny.org (planned)
- **Blog**: https://blog.oblibeny.org (planned)

### External Documentation

- **BOINC**: https://boinc.berkeley.edu/
- **Rust**: https://www.rust-lang.org/learn
- **Elixir**: https://elixir-lang.org/getting-started/introduction.html
- **Lean 4**: https://lean-lang.org/lean4/doc/
- **ArangoDB**: https://www.arangodb.com/docs/stable/
- **Nix**: https://nixos.org/manual/nix/stable/
- **Nickel**: https://nickel-lang.org/
- **Phoenix**: https://www.phoenixframework.org/
- **RSR Framework**: https://rhodium-standard.org (planned)
- **TPCF**: https://tpcf.standard.org (planned)
- **Palimpsest License**: https://palimpsest.license (planned)

### Papers & Research

- **Byzantine Fault Tolerance**: Castro & Liskov, "Practical Byzantine Fault Tolerance" (1999)
- **Capability-based Security**: Miller et al., "Robust Composition" (2006)
- **Dependent Types**: Martin-Löf, "Intuitionistic Type Theory" (1984)
- **Volunteer Computing**: Anderson, "BOINC: A System for Public-Resource Computing" (2004)

## Contact

- **General**: hello@oblibeny.org
- **Security**: security@oblibeny.org
- **Conduct**: conduct@oblibeny.org
- **Press**: press@oblibeny.org
- **RSR**: rsr@oblibeny.org
- **AI Training**: ai-training@oblibeny.org

## Acknowledgments

This project stands on the shoulders of giants:

- **BOINC Project**: For enabling volunteer computing
- **Rust Community**: For memory safety without compromise
- **Elixir Community**: For fault-tolerant distributed systems
- **Lean Community**: For accessible formal verification
- **RSR Framework**: For standards of politically autonomous software
- **All volunteers**: Who donate computing power to science

See `.well-known/humans.txt` for detailed credits.

---

**Version**: 0.6.0
**Last Updated**: 2024-11-23
**Maintained By**: Oblibeny Core Team
**License**: CC0 (this document), MIT + Palimpsest-0.8 (code)

---

*"The first programming language developed with the cooperation of a global supercomputer."*

Welcome aboard! 🚀
