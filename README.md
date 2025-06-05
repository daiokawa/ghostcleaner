# Ghostcleaner 👻🧹

> Who you gonna call? **Ghostcleaner!**

A smart cleanup tool that busts the ghost files haunting your codebase after AI-powered coding sessions.

English | [日本語](README.ja.md)

## The Problem 👻

With AI pair programming tools like Claude, Cursor, and GitHub Copilot, developers are creating files at supernatural speeds:

- `project-v1`, `project-v2`, `project-v3`... `project-final-FINAL-真的最后` 
- Multiple `node_modules` graveyards from rapid prototyping
- Disk space vanishing faster than ghosts at dawn
- Old build artifacts haunting your system

**These ghost files are real** - and they're eating your disk space!

## Features ✨

- **👻 Ghost Detection**: Automatically finds and identifies ghost versions of your projects
- **🔍 Git Safety**: Won't bust projects with uncommitted changes (respects the living code)
- **🎯 Smart Targeting**: Only removes truly dead code, keeps your active projects safe
- **👀 Preview Mode**: See which ghosts will be busted before pulling the trigger
- **🌍 Multi-Language**: Works with Node.js, Python, Go, Rust, and more undead code

## Installation 🚀

### Quick Install (Recommended)

```bash
# One-line ghost buster
curl -sSL https://raw.githubusercontent.com/daiokawa/ghostcleaner/main/scripts/install-one-liner.sh | bash

# Or with wget
wget -qO- https://raw.githubusercontent.com/daiokawa/ghostcleaner/main/scripts/install-one-liner.sh | bash
```

### Package Managers

```bash
# Homebrew (macOS/Linux)
brew install ghostcleaner

# npm (cross-platform)
npm install -g ghostcleaner

# pip (cross-platform)
pip install ghostcleaner
```

### Manual Installation

```bash
# Download the ghost buster
curl -sSL https://raw.githubusercontent.com/daiokawa/ghostcleaner/main/ghostcleaner.sh -o ghostcleaner

# Give it power
chmod +x ghostcleaner

# Deploy to your system
sudo mv ghostcleaner /usr/local/bin/
```

### From Source

```bash
git clone https://github.com/daiokawa/ghostcleaner.git
cd ghostcleaner
./install.sh
```

## Usage 👻

```bash
# See what ghosts are haunting your system (recommended first step)
ghostcleaner --dry-run

# Bust those ghosts! (removes old caches and build artifacts)
ghostcleaner

# AGGRESSIVE MODE: Bust even more ghosts (old project versions)
ghostcleaner --aggressive

# Use custom config
ghostcleaner --config ~/.ghostcleanerrc
```

### NEW in v1.2.0: Automatic Ghost Detection 🔄

Set up weekly ghost hunting (safe notification mode):
```bash
./scripts/setup-cron.sh
```

This will:
- 👀 Check for ghosts weekly
- 📱 Send macOS notifications when ghosts are found
- 🛡️ Never delete anything automatically (notification only)
- 📝 Keep logs of all findings

## What Gets Busted? 🎯

### Safe Mode (Default)
- 📦 Package manager caches (npm, pip, Homebrew)
- 🏗️ Build artifacts older than 60 days (`.next`, `dist`, `build`)
- 📁 `node_modules` not touched for 90+ days
- 🕳️ Empty directories (ghost towns)

### NEW in v1.1.0: Xcode Ghosts 🍎👻
- 📱 **iOS Simulators** - The biggest ghosts! (often 5GB+)
  - ✅ **100% safe to delete** - Xcode recreates them when needed
  - 💡 Just open Xcode → Window → Devices when you need a specific model
- 🔨 **DerivedData** - Build caches that rebuild automatically
- 📼 **Old Archives** - App archives older than 60 days

### Aggressive Mode 👻💀
- 🗂️ Old versions of your projects (keeps only the freshest)
- 👻 Ghost projects like:
  - `my-app-v1`, `my-app-v2` → keeps latest
  - `project-2024-01-01` → keeps most recent
  - `website-backup`, `website-old` → keeps `website`

## Configuration 🔧

Create a `.ghostcleanerrc` file in your home directory:

```yaml
# Directories to hunt for ghosts
scan_dirs:
  - ~/Desktop
  - ~/Downloads
  - ~/projects

# Patterns to protect (sacred ground)
ignore:
  - "*.important"
  - "production/*"

# Ghost age thresholds (days)
thresholds:
  node_modules: 90
  build_artifacts: 60
  
# Additional ghost signatures
ghost_patterns:
  - "*-backup"
  - "*-old"
  - "*-copy"
  - "*.bak"
```

## FAQ: "But What About My Simulators?" 📱

**Q: Is it really safe to delete iOS Simulators?**

**A: YES! 100% safe!** Here's why:
- Simulators are just virtual devices, not system files
- Xcode recreates them instantly when needed
- You probably don't need iPhone 8, X, 11, 12, 13, 14, 15, AND 16 simulators
- Each simulator can be 1-2GB (that's a lot of ghosts!)

**Example**: Bought a new iPhone 16 Pro? Just create that one simulator when you need it. Done! 

## Safety Features 🛡️

- 🚨 Never deletes files with recent activity
- 🔒 Git repository protection (checks for uncommitted changes)
- 📊 Detailed logging of all ghost busting activities
- 👻 Always keeps the latest version (no accidental exorcisms)
- 📝 Creates activity logs for recovery if needed
- 📱 Simulator deletion is reversible (just recreate in Xcode)

## The Story Behind Ghostcleaner 📖

In the age of AI-assisted development, we code at supernatural speeds. But with great power comes great disk usage. Every "let me try this real quick" creates a ghost - a half-finished project that haunts your filesystem forever.

Ghostcleaner was born from a very real problem: **AI makes us code so fast that our disks can't keep up!**

## Contributing 🤝

Help us bust more ghosts! We especially need:

- 👻 More ghost patterns to detect
- 🌍 Support for more languages and build tools
- 🔧 Windows native support (currently needs WSL)
- 🎨 Better ghost detection algorithms
- 🌐 Internationalization improvements

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## License 📄

MIT - Free as a ghost!

## Acknowledgments 🙏

Created to solve the very modern problem of "too many files, not enough disk space" in the AI era.

Special thanks to all the developers whose `node_modules` folders have achieved sentience.

---

**Remember**: Always use `--dry-run` first. No one wants to accidentally exorcise important code!

👻 *Happy Ghost Busting!* 👻