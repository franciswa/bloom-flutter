#!/usr/bin/env node
const { execSync } = require('child_process');

console.log('Starting Bloom app in web mode using Vite...');

try {
  // Set environment variables for Tamagui and reduced memory usage
  process.env.TAMAGUI_TARGET = 'web';
  process.env.NODE_OPTIONS = '--max-old-space-size=2048';
  
  // Use Vite for web development with a custom config that disables file watching
  const command = 'npx vite --port 3000 --config vite.no-watch.config.js';
  
  console.log(`Executing: ${command}`);
  execSync(command, { stdio: 'inherit' });
} catch (error) {
  console.error('Error starting web app:', error.message);
  process.exit(1);
}
