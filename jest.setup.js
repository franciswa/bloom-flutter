
// Mock React Native's Platform
jest.mock('react-native/Libraries/Utilities/Platform', () => ({
  OS: 'ios',
  select: jest.fn((dict) => dict.ios),
}));

// Mock AsyncStorage
jest.mock('@react-native-async-storage/async-storage', () => ({
  setItem: jest.fn(() => Promise.resolve()),
  getItem: jest.fn(() => Promise.resolve(null)),
  removeItem: jest.fn(() => Promise.resolve()),
  clear: jest.fn(() => Promise.resolve()),
}));

// Mock Expo Notifications
jest.mock('expo-notifications', () => ({
  getPermissionsAsync: jest.fn(),
  requestPermissionsAsync: jest.fn(),
  getExpoPushTokenAsync: jest.fn(),
  setNotificationHandler: jest.fn(),
  addNotificationReceivedListener: jest.fn(() => ({
    remove: jest.fn(),
  })),
}));

// Mock environment variables
process.env.EXPO_PROJECT_ID = 'test-project-id';
process.env.NODE_ENV = 'test';

// Silence React Native warnings
global.console = {
  ...console,
  warn: jest.fn(),
  error: jest.fn(),
};

// Mock timers
jest.useFakeTimers();
