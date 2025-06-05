#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const os = require('os');

console.log('\n✨ Ghostcleaner installed successfully!\n');

// Check if config exists
const configPath = path.join(os.homedir(), '.cleanerrc');
if (!fs.existsSync(configPath)) {
  console.log('💡 No config file found. You can create one at ~/.cleanerrc');
  console.log('   Example config available in:', path.join(__dirname, '..', 'example.cleanerrc'));
}

// Platform-specific instructions
if (os.platform() === 'win32') {
  console.log('\n📋 Windows users:');
  console.log('   Make sure you have WSL or Git Bash installed for full functionality.');
} else if (os.platform() === 'darwin') {
  console.log('\n📋 macOS users:');
  console.log('   The tool works with the default bash 3.2, but consider upgrading:');
  console.log('   brew install bash');
}

console.log('\n🚀 Get started with:');
console.log('   ghostcleaner --help');
console.log('   ghostcleaner --dry-run\n');