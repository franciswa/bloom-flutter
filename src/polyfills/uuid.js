// Enhanced UUID polyfill for web that doesn't require crypto
// This is a direct replacement for the crypto.randomUUID() function

// Implementation of RFC4122 v4 UUID
export function randomUUID() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
    const r = Math.random() * 16 | 0;
    const v = c === 'x' ? r : (r & 0x3 | 0x8);
    return v.toString(16);
  });
}

// For compatibility with different import styles
export const v4 = randomUUID;

// Add compatibility with both named and default exports
const uuid = {
  randomUUID,
  v4
};

export default uuid;

// Add compatibility with CommonJS require
if (typeof module !== 'undefined') {
  module.exports = {
    randomUUID,
    v4,
    default: uuid
  };
}
