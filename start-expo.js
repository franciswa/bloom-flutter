#!/usr/bin/env node
const { execSync } = require('child_process');
const { platform } = require('os');

// Function to increase file watch limit on Linux
function increaseWatchLimit() {
  try {
    console.log('Attempting to increase file watch limit...');
    
    // Check if we're on Linux
    if (platform() === 'linux') {
      // Try to increase the watch limit temporarily
      execSync('sudo sysctl -w fs.inotify.max_user_watches=524288 || true', { stdio: 'inherit' });
      console.log('File watch limit increased (or command was skipped due to permissions)');
    } else {
      console.log('Not on Linux, skipping watch limit increase');
    }
  } catch (error) {
    console.log('Could not increase watch limit, continuing anyway:', error.message);
  }
}

// Function to start Expo with reduced watch options
function startExpo() {
  try {
    console.log('Starting Expo with extremely reduced watch options...');
    
    // Set environment variables to reduce Metro's resource usage
    process.env.NODE_OPTIONS = '--max-old-space-size=2048';
    
    // Use the optimized Metro config and limit workers
    const command = 'EXPO_METRO_CONFIG=./metro.config.optimized.js npx expo start --max-workers=1 --no-dev --minify';
    
    console.log(`Executing: ${command}`);
    execSync(command, { stdio: 'inherit' });
  } catch (error) {
    console.error('Error starting Expo:', error.message);
    process.exit(1);
  }
}

// Main execution
increaseWatchLimit();
startExpo();
