// Custom webpack configuration that completely ignores font files
const path = require('path');
const webpack = require('webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const { CleanWebpackPlugin } = require('clean-webpack-plugin');
const CopyPlugin = require('copy-webpack-plugin');
const createExpoWebpackConfigAsync = require('@expo/webpack-config');

// This is a custom webpack configuration that completely ignores font files
module.exports = async function (env, argv) {
  // Get the default Expo webpack config as a starting point
  const expoConfig = await createExpoWebpackConfigAsync(
    {
      ...env,
      // Disable font loading completely
      disableFontLoading: true,
    },
    argv
  );

  // Create a completely custom webpack config
  return {
    mode: expoConfig.mode,
    entry: expoConfig.entry,
    output: expoConfig.output,
    devtool: expoConfig.devtool,
    devServer: expoConfig.devServer,
    
    // Add polyfills for crypto and other Node.js modules
    resolve: {
      extensions: ['.web.js', '.web.jsx', '.web.ts', '.web.tsx', '.js', '.jsx', '.ts', '.tsx'],
      alias: {
        'react-native$': 'react-native-web',
        'crypto': require.resolve('crypto-browserify'),
        'stream': require.resolve('stream-browserify'),
        'buffer': require.resolve('buffer'),
        'process': require.resolve('process/browser'),
        'expo-modules-core/build/uuid/uuid.web': path.resolve(__dirname, 'src/polyfills/uuid.js'),
        'expo-modules-core/node_modules/uuid': path.resolve(__dirname, 'src/polyfills/uuid.js'),
      },
      fallback: {
        crypto: require.resolve('crypto-browserify'),
        stream: require.resolve('stream-browserify'),
        buffer: require.resolve('buffer'),
        process: require.resolve('process/browser'),
        vm: false,
      },
    },
    
    module: {
      rules: [
        // JavaScript/TypeScript
        {
          test: /\.(js|jsx|ts|tsx)$/,
          exclude: /node_modules/,
          use: {
            loader: 'babel-loader',
            options: {
              presets: ['babel-preset-expo'],
            },
          },
        },
        // Images
        {
          test: /\.(png|jpe?g|gif)$/i,
          use: ['file-loader'],
        },
        // SVG
        {
          test: /\.svg$/,
          use: ['@svgr/webpack'],
        },
        // Completely ignore font files
        {
          test: /\.(woff|woff2|eot|ttf|otf)$/i,
          use: 'null-loader',
        },
      ],
    },
    
    plugins: [
      new CleanWebpackPlugin(),
      new HtmlWebpackPlugin({
        template: path.resolve(__dirname, 'web/index.html'),
        filename: 'index.html',
      }),
      new webpack.ProvidePlugin({
        process: 'process/browser',
        Buffer: ['buffer', 'Buffer'],
      }),
      // Define environment variables
      new webpack.DefinePlugin({
        'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV || 'development'),
        '__DEV__': JSON.stringify(process.env.NODE_ENV !== 'production'),
      }),
      // Copy static assets
      new CopyPlugin({
        patterns: [
          {
            from: path.resolve(__dirname, 'assets'),
            to: 'assets',
            filter: (resourcePath) => {
              // Skip font files
              return !resourcePath.match(/\.(woff|woff2|eot|ttf|otf)$/i);
            },
          },
        ],
      }),
    ],
  };
};
