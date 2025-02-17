export default {
  expo: {
    name: 'takeout demo',
    slug: 'takeout-demo',
    jsEngine: 'hermes',
    scheme: 'myapp',
    version: '1.0.0',
    orientation: 'portrait',
    icon: './assets/icon.png',
    userInterfaceStyle: 'automatic',
    splash: {
      image: './assets/splash.png',
      contentFit: 'contain',
      backgroundColor: '#ffffff',
    },
    updates: {
      fallbackToCacheTimeout: 0,
      url: 'https://u.expo.dev/your-project-id',
    },
    assetBundlePatterns: ['**/*'],
    ios: {
      supportsTablet: true,
      bundleIdentifier: 'dev.tamagui.takeoutdemo',
      buildNumber: '6',
    },
    android: {
      softwareKeyboardLayoutMode: 'pan',
      adaptiveIcon: {
        foregroundImage: './assets/adaptive-icon.png',
        backgroundColor: '#FFFFFF',
      },
      package: 'dev.tamagui.takeoutdemo',
      permissions: ['android.permission.RECORD_AUDIO'],
      versionCode: 3,
    },
    web: {
      favicon: './assets/favicon.png',
      bundler: 'metro',
    },
    plugins: [
      [
        'expo-notifications',
        {
          icon: './assets/icon.png',
          color: '#ffffff',
        },
      ],
      [
        'expo-image-picker',
        {
          photosPermission: 'The app accesses your photos to let you share them with your friends.',
        },
      ],
      'expo-apple-authentication',
      'expo-router',
      'expo-build-properties',
      'expo-font',
    ],
    fonts: [
      {
        asset: 'assets/fonts/Geist-VariableFont_wght.ttf',
        family: 'Geist',
      },
      {
        asset: 'assets/fonts/OpenSauceOne-Light.ttf',
        family: 'OpenSauceOne',
        weight: '300',
      },
      {
        asset: 'assets/fonts/OpenSauceOne-Regular.ttf',
        family: 'OpenSauceOne',
        weight: '400',
      },
      {
        asset: 'assets/fonts/OpenSauceOne-Medium.ttf',
        family: 'OpenSauceOne',
        weight: '500',
      },
      {
        asset: 'assets/fonts/OpenSauceOne-SemiBold.ttf',
        family: 'OpenSauceOne',
        weight: '600',
      },
      {
        asset: 'assets/fonts/OpenSauceOne-Bold.ttf',
        family: 'OpenSauceOne',
        weight: '700',
      },
    ],
    extra: {
      router: {
        origin: false,
      },
    },
  },
}
