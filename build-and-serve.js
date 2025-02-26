#!/usr/bin/env node

const { execSync } = require('child_process');
const path = require('path');
const http = require('http');
const fs = require('fs');
const { promisify } = require('util');

const PORT = process.env.PORT || 3000;
const BUILD_DIR = path.join(__dirname, 'web-build');

// MIME types for different file extensions
const MIME_TYPES = {
  '.html': 'text/html',
  '.js': 'text/javascript',
  '.css': 'text/css',
  '.json': 'application/json',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.gif': 'image/gif',
  '.svg': 'image/svg+xml',
  '.ico': 'image/x-icon',
  '.woff': 'font/woff',
  '.woff2': 'font/woff2',
  '.ttf': 'font/ttf',
  '.otf': 'font/otf',
  '.eot': 'application/vnd.ms-fontobject',
};

async function buildWebApp() {
  console.log('Building web app...');
  try {
    // Set environment variables
    process.env.TAMAGUI_TARGET = 'web';
    
    // Build the web app
    execSync('npx expo export:web', {
      stdio: 'inherit',
      env: {
        ...process.env,
        NODE_OPTIONS: '--max-old-space-size=2048', // Limit memory usage
      },
    });
    
    console.log('Build completed successfully!');
    return true;
  } catch (error) {
    console.error('Build failed:', error.message);
    return false;
  }
}

function serveStaticFiles() {
  console.log(`Starting static file server on port ${PORT}...`);
  
  const server = http.createServer((req, res) => {
    // Default to index.html for root path
    let filePath = path.join(BUILD_DIR, req.url === '/' ? 'index.html' : req.url);
    
    // Check if the file exists
    fs.access(filePath, fs.constants.F_OK, (err) => {
      if (err) {
        // If the file doesn't exist, try serving index.html (for SPA routing)
        if (req.url.indexOf('.') === -1) {
          filePath = path.join(BUILD_DIR, 'index.html');
        } else {
          // File not found
          res.writeHead(404);
          res.end('File not found');
          return;
        }
      }
      
      // Get the file extension
      const extname = path.extname(filePath);
      const contentType = MIME_TYPES[extname] || 'application/octet-stream';
      
      // Read and serve the file
      fs.readFile(filePath, (err, content) => {
        if (err) {
          res.writeHead(500);
          res.end(`Server Error: ${err.code}`);
        } else {
          res.writeHead(200, { 'Content-Type': contentType });
          res.end(content, 'utf-8');
        }
      });
    });
  });
  
  server.listen(PORT, () => {
    console.log(`Server running at http://localhost:${PORT}/`);
    console.log('Press Ctrl+C to stop the server');
  });
  
  server.on('error', (err) => {
    console.error('Server error:', err.message);
  });
}

async function main() {
  const buildSuccess = await buildWebApp();
  if (buildSuccess) {
    serveStaticFiles();
  }
}

main().catch(console.error);
