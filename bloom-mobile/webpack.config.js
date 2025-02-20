const createExpoWebpackConfigAsync = require('@expo/webpack-config');
const path = require('path');

module.exports = async function (env, argv) {
  const config = await createExpoWebpackConfigAsync(env, argv);

  // Add rule for font files
  config.module.rules.push({
    test: /\.(woff|woff2|eot|ttf|otf)$/,
    type: 'asset/resource',
    generator: {
      filename: 'static/fonts/[name][ext]'
    }
  });

  // Modify existing rules to handle font MIME types
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

  return config;
};
