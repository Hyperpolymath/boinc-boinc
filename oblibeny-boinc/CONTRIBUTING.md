# Contributing to Oblibeny BOINC

Thank you for your interest in contributing to Oblibeny! This document provides guidelines for contributing to the project.

## Ways to Contribute

1. **Code Contributions** - Implement features, fix bugs
2. **Documentation** - Improve docs, write tutorials
3. **Testing** - Write tests, report bugs
4. **Verification** - Help prove language properties
5. **BOINC Volunteering** - Donate computing power

## Getting Started

### Development Environment

**Option 1: Nix (Recommended)**

```bash
nix develop
```

**Option 2: Manual Setup**

```bash
./scripts/setup/dev-setup.sh
```

See [Development Guide](docs/development/README.md) for details.

### Project Structure

```
oblibeny-boinc/
├── rust-parser/        # Rust parser & analyzer
├── elixir-coordinator/ # Elixir/OTP coordination
├── lean-proofs/        # Lean 4 formal proofs
├── boinc-app/          # BOINC integration
├── deployment/         # Deploy configs
├── examples/           # Example programs
└── docs/               # Documentation
```

## Contribution Workflow

### 1. Find an Issue

- Browse [open issues](https://gitlab.com/oblibeny/boinc/issues)
- Look for `good-first-issue` or `help-wanted` labels
- Or propose a new feature/fix

### 2. Fork & Branch

```bash
# Fork on GitLab, then:
git clone https://gitlab.com/YOUR_USERNAME/oblibeny-boinc.git
cd oblibeny-boinc
git checkout -b feature/your-feature-name
```

### 3. Make Changes

**Code Style**:

- **Rust**: Follow `rustfmt` defaults
  ```bash
  cargo fmt
  cargo clippy -- -D warnings
  ```

- **Elixir**: Follow Elixir style guide
  ```bash
  mix format
  mix credo --strict
  ```

- **Lean 4**: Follow Mathlib4 conventions

**Commit Messages**:

```
<type>(<scope>): <subject>

<body>

<footer>
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

Examples:
```
feat(parser): add support for array literals

Implements parsing of fixed-size array literals with type annotations.

Closes #123
```

### 4. Test Your Changes

**Rust**:
```bash
cd rust-parser
cargo test
cargo bench
```

**Elixir**:
```bash
cd elixir-coordinator
mix test
mix dialyzer
```

**Lean**:
```bash
cd lean-proofs
lake build
```

**Integration**:
```bash
./scripts/test/integration.sh
```

### 5. Submit Pull Request

```bash
git push origin feature/your-feature-name
```

Then open a Merge Request on GitLab.

**MR Template**:

```markdown
## Description
What does this MR do?

## Related Issues
Closes #xxx

## Changes
- [ ] Added/modified feature X
- [ ] Updated documentation
- [ ] Added tests

## Testing
How was this tested?

## Checklist
- [ ] Tests pass locally
- [ ] Code follows style guide
- [ ] Documentation updated
- [ ] CHANGELOG updated
```

## Specific Contribution Areas

### Rust Parser

**What to work on**:
- Add new language features
- Improve error messages
- Optimize performance
- Add more analysis passes

**Key files**:
- `src/parser/parser.rs` - Parser logic
- `src/analyzer/` - Analysis passes
- `src/ast/` - AST definitions

### Elixir Coordinator

**What to work on**:
- Improve work generation
- Better result validation
- Performance optimization
- New properties

**Key files**:
- `lib/coordinator/work_generator.ex`
- `lib/coordinator/result_validator.ex`
- `lib/coordinator/proof_tracker.ex`

### Lean 4 Proofs

**What to work on**:
- Complete existing proofs (remove `sorry`)
- Add properties 4-7
- Improve tactics
- Add more lemmas

**Key files**:
- `Oblibeny/Properties/*.lean`
- `Oblibeny/Semantics.lean`

**Proof Guidelines**:
- Use readable proof terms
- Add comments explaining strategy
- Break large proofs into lemmas
- Use automation where appropriate

### Documentation

**What to work on**:
- API documentation
- Tutorials
- Architecture guides
- Deployment guides

**Style**:
- Clear, concise
- Code examples
- Diagrams where helpful
- Link to related docs

### Testing

**What to work on**:
- Unit tests
- Integration tests
- Property-based tests
- Benchmarks

**Coverage Goals**:
- Rust: >80%
- Elixir: >80%
- Lean: All theorems proven

## Code Review Process

1. **Automated Checks** - CI/CD must pass
2. **Review** - At least one maintainer review
3. **Discussion** - Address feedback
4. **Approval** - Maintainer approves
5. **Merge** - Squash & merge to main

**Review Criteria**:
- Correctness
- Code quality
- Test coverage
- Documentation
- Performance

## Community Guidelines

### Code of Conduct

Be respectful, inclusive, and constructive.

- ✅ Welcome newcomers
- ✅ Help others learn
- ✅ Give constructive feedback
- ❌ No harassment or discrimination
- ❌ No trolling or spam

### Communication

- **Issues**: Bug reports, feature requests
- **Merge Requests**: Code reviews
- **Discussions**: Design discussions
- **Chat**: Real-time help (Discord/Matrix)

## Recognition

Contributors are recognized in:
- `CONTRIBUTORS.md`
- Release notes
- Project website

Significant contributors may be invited to join the maintainer team.

## Development Tips

### Debugging

**Rust Parser**:
```bash
RUST_LOG=debug ./oblibeny analyze -i program.obl
```

**Elixir Coordinator**:
```elixir
iex> Logger.configure(level: :debug)
iex> Coordinator.generate_work("1", 1)
```

**Lean Proofs**:
```lean
#check my_theorem
#print my_theorem
```

### Performance

**Profile Rust**:
```bash
cargo bench
cargo flamegraph --bin oblibeny
```

**Profile Elixir**:
```elixir
:fprof.trace([:start])
# ... run code ...
:fprof.trace([:stop])
:fprof.analyse()
```

### Common Pitfalls

1. **Rust**: Don't use `unwrap()` in library code
2. **Elixir**: Avoid blocking in GenServer callbacks
3. **Lean**: Don't overuse `sorry` in PRs
4. **Tests**: Always test edge cases

## Release Process

1. Update version in all components
2. Update CHANGELOG.md
3. Tag release: `git tag v0.7.0`
4. Push tag: `git push --tags`
5. CI builds and deploys

## Questions?

- Open an issue
- Ask in Discord/Matrix
- Email: dev@oblibeny.org

## License

By contributing, you agree your contributions will be licensed under GPL-3.0-or-later.

---

Thank you for contributing to Oblibeny! 🚀
