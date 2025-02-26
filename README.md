# Bloom Mobile App

## Running the App

### Issue with File Watchers (ENOSPC Error)

If you encounter the following error when trying to run the app:

```
Error: ENOSPC: System limit for number of file watchers reached
```

This is a common issue with Expo and React Native development, especially on Linux systems. The error occurs because Metro bundler tries to watch too many files, exceeding the system's limit.

### Solutions

We've provided several optimized ways to run the app that should avoid this issue:

#### Option 1: Serve the pre-built web version (RECOMMENDED)

```bash
npm run serve:web
```

This script:
- Serves the pre-built web version of the app using a simple static server
- Does not require file watching or compilation
- The app will be available at http://localhost:3005
- **This is the most reliable solution and should be your first choice**
- Note: This serves the already built version in the web-build directory

#### Option 2: Run in web mode using Vite

```bash
npm run start:web
```

This script:
- Starts the app in web mode using Vite instead of Expo
- Vite is more lightweight than Expo but may still encounter ENOSPC errors
- The app will be available at http://localhost:3000
- Note: Since file watching is disabled, you'll need to restart the server after making changes

#### Option 3: Use the optimized Expo starter (may still encounter ENOSPC on some systems)

```bash
npm run start:optimized
```

This script:
- Attempts to increase the system's file watch limit (requires sudo permissions)
- Starts Expo with reduced worker count and memory usage
- Uses an extremely optimized Metro configuration with minimal file watching
- Runs in production mode with minification to reduce resource usage

#### Option 3: Manually increase system file watch limit

If you want to use the regular Expo commands, you can manually increase your system's file watch limit:

```bash
# Temporarily increase the limit
sudo sysctl -w fs.inotify.max_user_watches=524288

# Then run the app normally
npm start
```

To make this change permanent, add the following to `/etc/sysctl.conf`:

```
fs.inotify.max_user_watches=524288
```

Then run:

```bash
sudo sysctl -p
```

## Other Available Scripts

- `npm start` - Start Expo development server (standard)
- `npm run android` - Start Expo and open on Android
- `npm run ios` - Start Expo and open on iOS
- `npm run web` - Start Expo in web mode
- `npm run build:web` - Build the web version using Expo
- `npm run build:vite` - Build the web version using Vite
- `npm run dev` - Run Vite development server
