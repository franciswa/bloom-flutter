const createExpoWebpackConfigAsync = require('@expo/webpack-config');
const path = require('path');

module.exports = async function (env, argv) {
  const config = await createExpoWebpackConfigAsync({
    ...env,
    babel: {
      dangerouslyAddModulePathsToTranspile: [
        '@tamagui/core',
        'tamagui',
        '@tamagui/config',
        '@tamagui/animations-react-native',
        '@tamagui/font-inter',
        '@tamagui/react-native-media-driver',
        '@tamagui/shorthands',
        '@tamagui/themes',
      ],
    },
  }, argv);

  // Add react-native-web aliases
  config.resolve.alias = {
    ...config.resolve.alias,
    'react-native$': 'react-native-web',
    'react-native-web': path.resolve(__dirname, 'node_modules/react-native-web'),
    // Add Tamagui aliases
    '@tamagui/core': path.resolve(__dirname, 'node_modules/@tamagui/core'),
    '@tamagui/web': path.resolve(__dirname, 'node_modules/@tamagui/web'),
  };

  // Add fallbacks for node modules
  config.resolve.fallback = {
    ...config.resolve.fallback,
    'react-native': 'react-native-web',
    'react-native-web/dist/exports/AppRegistry': 'react-native-web/dist/cjs/exports/AppRegistry',
    'react-native-web/dist/exports/Platform': 'react-native-web/dist/cjs/exports/Platform',
    'react-native-web/dist/exports/View': 'react-native-web/dist/cjs/exports/View',
    'react-native-web/dist/exports/Text': 'react-native-web/dist/cjs/exports/Text',
    'react-native-web/dist/exports/Image': 'react-native-web/dist/cjs/exports/Image',
    'react-native-web/dist/exports/Animated': 'react-native-web/dist/cjs/exports/Animated',
    'react-native-web/dist/exports/ActivityIndicator': 'react-native-web/dist/cjs/exports/ActivityIndicator',
    'react-native-web/dist/exports/NativeEventEmitter': 'react-native-web/dist/cjs/exports/NativeEventEmitter',
    'react-native-web/dist/exports/Dimensions': 'react-native-web/dist/cjs/exports/Dimensions',
    'react-native-web/dist/exports/Keyboard': 'react-native-web/dist/cjs/exports/Keyboard',
    'react-native-web/dist/exports/PanResponder': 'react-native-web/dist/cjs/exports/PanResponder',
    'react-native-web/dist/exports/ScrollView': 'react-native-web/dist/cjs/exports/ScrollView',
    'react-native-web/dist/exports/Switch': 'react-native-web/dist/cjs/exports/Switch',
    'react-native-web/dist/exports/TextInput': 'react-native-web/dist/cjs/exports/TextInput',
    'react-native-web/dist/exports/Linking': 'react-native-web/dist/cjs/exports/Linking',
    'react-native-web/dist/exports/UIManager': 'react-native-web/dist/cjs/exports/UIManager',
    'react-native-web/dist/exports/BackHandler': 'react-native-web/dist/cjs/exports/BackHandler',
    'react-native-web/dist/exports/DeviceEventEmitter': 'react-native-web/dist/cjs/exports/DeviceEventEmitter',
    'react-native-web/dist/exports/NativeModules': 'react-native-web/dist/cjs/exports/NativeModules',
    'react-native-web/dist/exports/useColorScheme': 'react-native-web/dist/cjs/exports/useColorScheme',
  };

  // Remove existing font rules
  config.module.rules = config.module.rules.filter(
    rule => !(rule.test && rule.test.toString().includes('ttf'))
  );

  // Add font handling rule
  config.module.rules.push({
    test: /\.(woff|woff2|eot|ttf|otf)$/,
    type: 'javascript/auto',
    use: {
      loader: 'url-loader',
      options: {
        limit: 8192,
        fallback: {
          loader: 'file-loader',
          options: {
            name: 'static/media/[name].[hash:8].[ext]',
          },
        },
      },
    },
  });

  // Set the port to 19006
  config.devServer = {
    ...config.devServer,
    port: 19006,
    historyApiFallback: true,
    hot: true,
    static: {
      directory: path.join(__dirname, 'public'),
    },
    headers: {
      'Access-Control-Allow-Origin': '*',
    },
  };

  return config;
};
