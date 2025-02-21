const { getDefaultConfig } = require('expo/metro-config');
const path = require('path');

const config = getDefaultConfig(__dirname);

// Add custom resolver for @ alias
config.resolver.alias = {
  '@': path.resolve(__dirname, 'src'),
};

// Handle TypeScript and JavaScript files
config.resolver.sourceExts = ['jsx', 'js', 'ts', 'tsx', 'json'];

// Support Tamagui
config.transformer.babelTransformerPath = require.resolve('react-native-svg-transformer');

module.exports = config;
