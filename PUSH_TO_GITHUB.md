# Push to GitHub Guide

Your Ghostcleaner repository is ready! Here's how to push it to GitHub:

## 1. Create Repository on GitHub

Go to: https://github.com/new

- **Repository name**: `ghostcleaner`
- **Description**: `Smart cleanup tool for the AI-assisted development era - removes old versions while keeping the latest`
- **Public**: ✓
- **Do NOT** initialize with README, .gitignore, or license (we already have them)

## 2. Push Your Code

After creating the empty repository on GitHub, run these commands:

```bash
cd ~/Documents/ghostcleaner

# Add your GitHub repository as remote
git remote add origin https://github.com/YOUR_USERNAME/ghostcleaner.git

# Push to GitHub
git branch -M main
git push -u origin main
```

## 3. Create Release

```bash
# Tag the version
git tag -a v1.0.0 -m "Initial release: Ghostcleaner v1.0.0"
git push origin v1.0.0
```

## 4. Update README URLs

Replace `yourusername` with your actual GitHub username in:
- README.md
- README.ja.md
- All installation scripts

```bash
# Quick replace (macOS)
find . -type f -name "*.md" -o -name "*.sh" -o -name "*.rb" | xargs sed -i '' 's/yourusername/YOUR_ACTUAL_USERNAME/g'

# Commit the changes
git add .
git commit -m "Update GitHub URLs"
git push
```

## 5. Set Repository Topics

On your GitHub repository page, click the gear icon next to "About" and add topics:
- `ai`
- `cleanup`
- `disk-space`
- `cli`
- `developer-tools`
- `node-modules`
- `cache-cleaner`

## 6. Share with the Community!

### Reddit
- r/programming
- r/webdev
- r/node

### Twitter/X
```
🧹 Just released Ghostcleaner - a tool born from the AI coding era!

When AI helps you code 10x faster, your disk fills up 10x faster too 😅

✅ Keeps latest versions
✅ Git safety checks  
✅ Multi-language support

https://github.com/YOUR_USERNAME/ghostcleaner
```

### Product Hunt
Consider launching on Product Hunt with the tagline:
"Smart cleanup for the AI development era"

## 7. Optional: Homebrew Tap

To make it installable via Homebrew:

```bash
# Create a homebrew tap repository
# Name: homebrew-tap
# Then users can:
brew tap YOUR_USERNAME/tap
brew install ghostcleaner
```

---

🎉 Congratulations on creating a tool that solves a very modern problem!