# BLOOM

A React Native application built with Expo, Tamagui, and Supabase.

## Development in Replit

This project is configured to run in Replit. To get started:

1. Fork this project in Replit
2. Let the environment setup complete (this may take a few minutes)
3. The development server will start automatically
4. View the app in the Replit browser window

## Local Development

To run this project locally:

1. Clone the repository
2. Install dependencies:
   ```bash
   npm install
   ```
3. Start the development server:
   ```bash
   npx expo start
   ```

## Tech Stack

- React Native / Expo
- TypeScript
- Tamagui for UI components
- React Navigation for routing
- Supabase for backend

## Project Structure

```
├── src/
│   ├── screens/      # Screen components
│   ├── components/   # Reusable components
│   └── services/     # API and business logic
├── App.tsx          # Main application component
└── tamagui.config.ts # Tamagui configuration
