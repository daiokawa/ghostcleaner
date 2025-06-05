# Contributing to Ghostcleaner

Thank you for your interest in contributing to Ghostcleaner! This tool addresses a very real problem in the AI-assisted development era, and we welcome all contributions.

## How to Contribute

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/amazing-feature`)
3. **Commit your changes** (`git commit -m 'Add amazing feature'`)
4. **Push to the branch** (`git push origin feature/amazing-feature`)
5. **Open a Pull Request**

## Development Setup

```bash
# Clone your fork
git clone https://github.com/daiokawa/ghostcleaner.git
cd ghostcleaner

# Make scripts executable
chmod +x *.sh test/*.sh

# Run tests
./test/test-suite.sh
```

## Areas We Need Help

### 1. Language/Framework Support
- **Ruby**: Detect and clean `vendor/bundle`, `.bundle`
- **Java**: Handle `.gradle`, `target/`, `.m2` caches
- **C/C++**: Clean `CMakeFiles`, `*.o`, build directories
- **.NET**: Clean `bin/`, `obj/`, NuGet caches
- **Rust**: Better handling of `target/` directories

### 2. Internationalization
- Proper i18n support (not just hardcoded messages)
- Support for more languages (Chinese, Spanish, Portuguese, etc.)
- Locale-aware date/size formatting

### 3. Platform Support
- Windows native support (without WSL)
- Better Linux distribution compatibility
- Package managers: apt, yum, snap packages

### 4. Smart Features
- Machine learning to detect "safe to delete" patterns
- Integration with cloud storage (mark for archival instead of deletion)
- Undo/restore functionality
- Real-time monitoring mode

### 5. Git Integration
- `git worktree` support
- Detect if changes are pushed (not just committed)
- Integration with GitHub/GitLab/Bitbucket APIs

## Code Style

- Use shellcheck for bash scripts
- Follow existing indentation (4 spaces)
- Add comments for complex logic
- Keep functions small and focused

## Testing

- Add tests for new features in `test/test-suite.sh`
- Ensure tests pass on macOS and Linux
- Test with both bash 3.2 (macOS default) and bash 4+

## Documentation

- Update README.md for new features
- Add examples to help text
- Update both English and Japanese docs if possible

## Release Process

1. Update version in `ghostcleaner.sh`
2. Update CHANGELOG.md
3. Tag the release: `git tag v1.x.x`
4. Update package manager formulas

## Questions?

Feel free to open an issue for discussion before making large changes!

## Code of Conduct

Be respectful and inclusive. We're all here to solve the "too many files" problem together! 😊