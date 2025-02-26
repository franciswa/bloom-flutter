#!/usr/bin/env node

const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = process.env.PORT || 3005;
const WEB_BUILD_DIR = path.join(__dirname, 'web-build');
const STATIC_DIR = path.join(__dirname, 'assets');

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

// Create a simple HTML page with project information
function createFallbackHTML() {
  return `
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Bloom Mobile App</title>
  <style>
    body {
      font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
      line-height: 1.5;
      color: #333;
      max-width: 800px;
      margin: 0 auto;
      padding: 20px;
    }
    h1 {
      color: #2a9d8f;
      border-bottom: 2px solid #e9c46a;
      padding-bottom: 10px;
    }
    h2 {
      color: #e76f51;
      margin-top: 30px;
    }
    pre {
      background-color: #f5f5f5;
      padding: 15px;
      border-radius: 5px;
      overflow-x: auto;
    }
    .card {
      background-color: #f8f9fa;
      border-radius: 8px;
      padding: 20px;
      margin: 20px 0;
      box-shadow: 0 4px 6px rgba(0,0,0,0.1);
    }
    .error {
      background-color: #ffebee;
      border-left: 4px solid #f44336;
      padding: 15px;
      margin: 20px 0;
    }
    .success {
      background-color: #e8f5e9;
      border-left: 4px solid #4caf50;
      padding: 15px;
      margin: 20px 0;
    }
  </style>
</head>
<body>
  <h1>Bloom Mobile App</h1>
  
  <div class="card">
    <h2>Project Overview</h2>
    <p>Bloom Mobile is a React Native application built with Expo that appears to be a dating/matching app with a focus on compatibility based on both astrological factors and personality questionnaires.</p>
  </div>

  <div class="card">
    <h2>Current Status</h2>
    <p>The application is currently experiencing build issues that prevent it from running in Expo Go (mobile) or Expo launch (local Linux desktop).</p>
    <div class="error">
      <p><strong>Error:</strong> The app is encountering webpack compilation errors related to TypeScript type exports.</p>
    </div>
  </div>

  <div class="card">
    <h2>Identified Issues</h2>
    <ul>
      <li><strong>Directory Confusion:</strong> There are two versions of the project - one in the parent directory and one in a nested directory.</li>
      <li><strong>Environment Variables:</strong> The nested directory has placeholder values for Supabase credentials.</li>
      <li><strong>Configuration Differences:</strong> The parent directory has more recent and complete configurations.</li>
      <li><strong>Network/URL Issues:</strong> The app is trying to access a Replit URL, which might not be accessible from Expo Go or the local Linux desktop.</li>
      <li><strong>System Limitations:</strong> Encountering "ENOSPC: System limit for number of file watchers reached" errors.</li>
    </ul>
  </div>

  <div class="card">
    <h2>Recommended Solutions</h2>
    <ol>
      <li>Consolidate the project structure to use only one directory.</li>
      <li>Ensure correct environment variables are available in the chosen directory.</li>
      <li>Use a production build approach instead of development mode to reduce resource usage.</li>
      <li>Configure the app to use localhost instead of the Replit URL.</li>
    </ol>
  </div>
</body>
</html>
  `;
}

// Check if web-build directory exists
const webBuildExists = fs.existsSync(WEB_BUILD_DIR) && fs.statSync(WEB_BUILD_DIR).isDirectory();

// Start the server
const server = http.createServer((req, res) => {
  console.log(`Request: ${req.method} ${req.url}`);
  
  // Determine the file path
  let filePath;
  
  if (webBuildExists) {
    // Serve from web-build directory if it exists
    filePath = path.join(WEB_BUILD_DIR, req.url === '/' ? 'index.html' : req.url);
  } else {
    // Serve fallback HTML for root path
    if (req.url === '/') {
      res.writeHead(200, { 'Content-Type': 'text/html' });
      res.end(createFallbackHTML());
      return;
    }
    
    // Try to serve from static directory
    filePath = path.join(STATIC_DIR, req.url);
  }
  
  // Get the file extension
  const extname = path.extname(filePath);
  const contentType = MIME_TYPES[extname] || 'application/octet-stream';
  
  // Check if the file exists
  fs.access(filePath, fs.constants.F_OK, (err) => {
    if (err) {
      if (webBuildExists && req.url.indexOf('.') === -1) {
        // For SPA routing, serve index.html for paths without file extensions
        filePath = path.join(WEB_BUILD_DIR, 'index.html');
        fs.readFile(filePath, (err, content) => {
          if (err) {
            res.writeHead(404);
            res.end('File not found');
          } else {
            res.writeHead(200, { 'Content-Type': 'text/html' });
            res.end(content, 'utf-8');
          }
        });
      } else {
        // File not found
        res.writeHead(404);
        res.end('File not found');
      }
      return;
    }
    
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
  console.log(`Serving ${webBuildExists ? 'web-build directory' : 'fallback HTML'}`);
  console.log('Press Ctrl+C to stop the server');
});

server.on('error', (err) => {
  console.error('Server error:', err.message);
});
