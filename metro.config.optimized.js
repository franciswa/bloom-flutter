// Learn more https://docs.expo.io/guides/customizing-metro
const { getDefaultConfig } = require('expo/metro-config');
const path = require('path');

/** @type {import('expo/metro-config').MetroConfig} */
const config = getDefaultConfig(__dirname);

// Add support for SVG files
config.transformer.babelTransformerPath = require.resolve('react-native-svg-transformer');
config.resolver.assetExts = config.resolver.assetExts.filter(ext => ext !== 'svg');
config.resolver.sourceExts = [...config.resolver.sourceExts, 'svg'];

// Include font files in asset processing for EAS builds
config.resolver.assetExts = [...config.resolver.assetExts, 'ttf', 'otf', 'woff', 'woff2', 'eot'];

// Extremely aggressive file watcher reduction to avoid ENOSPC errors
config.watchFolders = [path.resolve(__dirname, 'src')];

// Block almost all node_modules from being watched
config.resolver.blockList = [
  /node_modules\/(?!(@react-native|react-native|expo)\/.*$)/,
  /node_modules\/.*\/node_modules/,
  /node_modules\/react-native\/ReactAndroid/,
  /node_modules\/react-native\/Libraries/,
  /node_modules\/react-native-web/,
  /node_modules\/react-native-gesture-handler/,
  /node_modules\/react-native-reanimated/,
  /node_modules\/react-native-safe-area-context/,
  /node_modules\/react-native-screens/,
  /node_modules\/react-native-svg/,
  /node_modules\/@react-navigation/,
  /node_modules\/@rneui/,
  /node_modules\/@tamagui/,
  /node_modules\/tamagui/,
  /__tests__\/.*/,
  /.*\.test\.(js|ts|tsx)/,
  /.*\.spec\.(js|ts|tsx)/,
];

// Explicitly set maxWorkers to reduce resource usage
config.maxWorkers = 1;

// Disable source maps to reduce memory usage
config.transformer.minifierConfig = {
  ...config.transformer.minifierConfig,
  sourceMap: false,
};

// Optimize caching
config.cacheStores = [
  {
    type: 'memory',
    options: {
      maxSize: 50 * 1024 * 1024, // 50 MB
    },
  },
];

// Disable hot module reloading to reduce file watching
config.resolver.enableGlobalPackages = false;
config.resolver.useWatchman = false;

module.exports = config;
