const createExpoWebpackConfigAsync = require('@expo/webpack-config');
const path = require('path');
const webpack = require('webpack');

module.exports = async function (env, argv) {
  const config = await createExpoWebpackConfigAsync(env, argv);

  // Add rules for font and SVG files
  config.module.rules.push(
    {
      test: /\.(woff|woff2|eot|ttf|otf)$/,
      type: 'asset/resource',
      generator: {
        filename: 'static/fonts/[name][ext]'
      }
    },
    {
      test: /\.svg$/,
      use: ['@svgr/webpack']
    }
  );

  // Modify existing rules to handle font and SVG MIME types
  config.module.rules = config.module.rules.map(rule => {
    if (rule.oneOf) {
      rule.oneOf = rule.oneOf.map(oneOf => {
        if (oneOf.loader && oneOf.loader.includes('file-loader')) {
          return {
            ...oneOf,
            options: {
              ...oneOf.options,
              name: '[name].[ext]',
              outputPath: 'static/fonts/'
            }
          };
        }
        return oneOf;
      });
    }
    return rule;
  });

  // Add resolve extensions
  config.resolve.extensions = [
    '.web.js',
    '.web.jsx',
    '.web.ts',
    '.web.tsx',
    '.js',
    '.jsx',
    '.ts',
    '.tsx',
    '.svg'
  ];

  // Add module aliases and fallbacks
  config.resolve.alias = {
    ...config.resolve.alias,
    'expo-modules-core/build/uuid/uuid.web': path.resolve(__dirname, 'src/polyfills/uuid.js'),
  };

  return config;
};
