import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import path from 'path';

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  resolve: {
    modules: [
      path.resolve(__dirname, 'src/polyfills'),
      'node_modules'
    ],
    alias: {
      'react-native': 'react-native-web',
      'crypto': path.resolve(__dirname, 'src/polyfills/crypto.js'),
      'expo-modules-core/build/uuid/uuid.web': path.resolve(__dirname, 'src/polyfills/uuid.js'),
      'expo-modules-core/node_modules/uuid': path.resolve(__dirname, 'src/polyfills/uuid.js'),
      '@react-native-community/datetimepicker': path.resolve(__dirname, 'src/polyfills/DateTimePicker.web.jsx'),
      'react-native/Libraries/Image/AssetRegistry': path.resolve(__dirname, 'src/polyfills/AssetResolver.js'),
      'react-native/Libraries/Image/AssetSourceResolver': path.resolve(__dirname, 'src/polyfills/AssetResolver.js'),
      '@react-native/assets-registry/registry': path.resolve(__dirname, 'src/polyfills/AssetResolver.js'),
      'react-native-web/Libraries/Utilities/codegenNativeComponent': path.resolve(__dirname, 'src/polyfills/codegenNativeComponent.js'),
      '@': path.resolve(__dirname, 'src'),
    },
  },
  define: {
    // Define global variables
    'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV || 'development'),
    '__DEV__': JSON.stringify(process.env.NODE_ENV !== 'production'),
    'global': 'window',
  },
  optimizeDeps: {
    esbuildOptions: {
      // Node.js global to browser globalThis
      define: {
        global: 'globalThis',
      },
    },
  },
  build: {
    outDir: 'web-build',
    sourcemap: true,
    commonjsOptions: {
      transformMixedEsModules: true,
    },
  },
  server: {
    port: 3000,
    open: true,
  },
});
