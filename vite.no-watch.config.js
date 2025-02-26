import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import { resolve } from 'path';

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src'),
    },
  },
  // Disable HMR and file watching to reduce file watchers
  server: {
    hmr: false,
    watch: {
      ignored: ['**/*'], // Ignore all files to prevent watching
    },
  },
  // Reduce memory usage
  build: {
    sourcemap: false,
    minify: true,
  },
  // Optimize dependencies
  optimizeDeps: {
    include: ['react', 'react-dom', 'react-native-web'],
  },
});
