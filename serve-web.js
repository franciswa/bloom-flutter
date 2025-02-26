#!/usr/bin/env node
const { execSync } = require('child_process');

console.log('Starting Bloom app using simple static server...');

try {
  // Use the simple-server.js to serve the web-build directory
  const command = 'node ./simple-server.js';
  
  console.log(`Executing: ${command}`);
  execSync(command, { stdio: 'inherit' });
} catch (error) {
  console.error('Error starting web app:', error.message);
  process.exit(1);
}
