# Changelog

All notable changes to Ghostcleaner will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- Full internationalization support
- Windows native support  
- Configuration file support
- Cloud storage integration
- Undo functionality

## [1.1.0] - 2024-12-19

### Added
- 🍎 **Xcode support** - The biggest ghosts revealed!
  - iOS Simulator devices (often 5GB+ of ghosts)
  - DerivedData (build caches)
  - Old Archives (60+ days)
- 📱 Clear messaging that simulators are 100% safe to delete
- 💡 Helpful hints about recreating simulators when needed

### Changed
- Section numbering updated to accommodate Xcode features
- More reassuring messages for nervous users

### Fun Fact
- One user found 5.7GB of simulator ghosts! That's a lot of iPhone models nobody needs

## [1.0.0] - 2024-12-19

### Added
- Initial release 🎉
- Smart version detection (keeps latest version)
- Git safety checks (skips uncommitted changes)
- Dry run mode
- Aggressive cleaning mode
- Support for multiple package managers (npm, pip, Homebrew)
- Cross-platform installation (curl, npm, Homebrew)
- Comprehensive test suite
- Japanese and English documentation

### Supported Cleanup Targets
- Package manager caches (npm, pip, Homebrew)
- Node.js: `node_modules`, `.next`
- Python: `__pycache__`, `venv`
- General: `dist`, `build`, empty directories
- Versioned projects (`*-v1`, `*-2024-01-01`, etc.)

### Safety Features
- Git repository detection
- Uncommitted changes protection
- Age-based thresholds
- Detailed logging
- Always keeps the latest version

## Background

Created to address the "AI development disk space crisis" - when AI pair programming tools help developers create files 10x faster, leading to disk space filling up in days instead of months!