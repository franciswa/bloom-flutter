module.exports = function(api) {
  api.cache(true);
  return {
    presets: [
      ['@babel/preset-env', { targets: { node: 'current' } }],
      '@babel/preset-typescript',
      ['@babel/preset-react', { runtime: 'automatic' }],
      '@babel/preset-flow',
      'module:metro-react-native-babel-preset'
    ],
    plugins: [
      ['@babel/plugin-proposal-private-methods', { loose: true }],
      ['@babel/plugin-proposal-class-properties', { loose: true }],
      [
        'module-resolver',
        {
          root: ['./src'],
          extensions: ['.ios.js', '.android.js', '.js', '.ts', '.tsx', '.json'],
          alias: {
            '@': './src',
          },
        },
      ],
    ]
  };
};
