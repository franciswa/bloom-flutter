const { expect } = require('@jest/globals');
const jestDom = require('@testing-library/jest-dom');
const jestNative = require('@testing-library/jest-native');

global.expect = expect;
expect.extend(jestDom);
expect.extend(jestNative);
