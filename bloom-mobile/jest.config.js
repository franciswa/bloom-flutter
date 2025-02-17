module.exports = {
  preset: 'react-native',
  moduleFileExtensions: ['ts', 'tsx', 'js', 'jsx', 'json', 'node'],
  setupFilesAfterEnv: [
    '<rootDir>/jest.setup.js',
    '@testing-library/jest-dom',
    '@testing-library/jest-native/extend-expect'
  ],
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/src/$1',
    '^react-native$': 'react-native-web',
    '^react-native/Libraries/Utilities/Platform$': 'react-native-web/dist/exports/Platform',
    '^react-native-reanimated$': 'react-native-reanimated/mock',
    '^react-native/Libraries/EventEmitter/NativeEventEmitter$': 'react-native/Libraries/EventEmitter/__mocks__/NativeEventEmitter',
    '\\.svg': '<rootDir>/__mocks__/svgMock.js',
    '\\.(jpg|jpeg|png|gif|eot|otf|webp|ttf|woff|woff2|mp4|webm|wav|mp3|m4a|aac|oga)$': '<rootDir>/__mocks__/fileMock.js',
  },
  testEnvironment: 'jest-environment-jsdom',
  testMatch: ['**/__tests__/**/*.test.[jt]s?(x)'],
  transform: {
    '^.+\\.(js|jsx|ts|tsx)$': ['babel-jest', { configFile: './babel.config.test.js' }],
  },
  transformIgnorePatterns: [
    'node_modules/(?!(@react-native|@react-native-js-polyfills|react-native|@react-navigation|@rneui|@expo|expo|react-navigation|@unimodules|unimodules|sentry-expo|native-base|react-native-svg))',
  ],
  collectCoverage: true,
  collectCoverageFrom: [
    'src/**/*.{js,jsx,ts,tsx}',
    '!src/**/*.d.ts',
    '!src/**/types.ts',
    '!src/utils/test-utils.ts',
  ],
  coverageThreshold: {
    global: {
      branches: 70,
      functions: 70,
      lines: 70,
      statements: 70,
    },
  },
};
