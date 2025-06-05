#!/bin/bash

# GitHub setup script for Ghostcleaner

echo "🚀 Setting up Ghostcleaner GitHub repository..."

# Initialize git repository
if [ ! -d .git ]; then
    git init
    echo "✓ Initialized git repository"
fi

# Add all files
git add .
git commit -m "Initial commit: Ghostcleaner v1.0.0

- Smart cleanup tool for AI-assisted development era
- Keeps latest versions, removes old iterations
- Git safety checks (skips uncommitted changes)
- Multi-language support (English/Japanese)
- Cross-platform installation (curl, npm, Homebrew)
- Comprehensive test suite

🤖 Created to solve the 'too many files' problem in AI development!"

echo "✓ Created initial commit"

# Create GitHub repository instructions
cat << 'EOF'

📋 Next steps to publish on GitHub:

1. Create a new repository on GitHub:
   https://github.com/new
   
   Repository name: ghostcleaner
   Description: Smart cleanup tool for the AI-assisted development era
   Public repository: ✓

2. Add the remote and push:
   git remote add origin https://github.com/YOUR_USERNAME/ghostcleaner.git
   git branch -M main
   git push -u origin main

3. Add topics on GitHub:
   ai, cleanup, disk-space, cli, developer-tools, node-modules

4. Create the first release:
   git tag -a v1.0.0 -m "Initial release"
   git push origin v1.0.0

5. Update README.md URLs:
   Replace "daiokawa" with your actual GitHub username

6. Optional: Set up GitHub Pages for documentation

🎉 Then share with the community!

EOF