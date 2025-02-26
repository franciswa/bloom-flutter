import React from 'react';
import { createRoot } from 'react-dom/client';
import { TamaguiProvider } from 'tamagui';
import config from '../tamagui.config';
import App from '../App';

// Polyfills
import 'react-native-url-polyfill/auto';

// Create root
const rootElement = document.getElementById('root');
if (!rootElement) throw new Error('Root element not found');
const root = createRoot(rootElement);

// Render app
root.render(
  <React.StrictMode>
    <TamaguiProvider config={config}>
      <App />
    </TamaguiProvider>
  </React.StrictMode>
);
