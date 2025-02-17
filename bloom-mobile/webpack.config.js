const createExpoWebpackConfigAsync = require('@expo/webpack-config');

module.exports = async function (env, argv) {
  const config = await createExpoWebpackConfigAsync({
    ...env,
    babel: {
      dangerouslyAddModulePathsToTranspile: ['@tamagui']
    }
  }, argv);

  // Override the existing font rule
  config.module.rules = config.module.rules.map(rule => {
    if (rule.test && rule.test.toString().includes('ttf|otf|woff')) {
      return {
        test: /\.(woff|woff2|eot|ttf|otf)$/,
        type: 'asset/resource',
        generator: {
          filename: 'static/media/[name].[hash][ext]'
        }
      };
    }
    return rule;
  });

  // Add resolve aliases for Tamagui
  config.resolve.alias = {
    ...config.resolve.alias,
    '@tamagui/core': '@tamagui/core/native',
    'react-native-web': 'react-native-web/dist/cjs',
    '@': './src'
  };

  return config;
};
