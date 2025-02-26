// Polyfill for crypto module in web environment
import { randomUUID } from './uuid';

// Create a minimal implementation of the crypto API
const crypto = {
  getRandomValues: function(array) {
    if (!(array instanceof Uint8Array || array instanceof Uint16Array || array instanceof Uint32Array)) {
      throw new Error('getRandomValues requires a Uint8Array, Uint16Array, or Uint32Array');
    }
    
    for (let i = 0; i < array.length; i++) {
      // Generate random values based on the array type
      if (array instanceof Uint8Array) {
        array[i] = Math.floor(Math.random() * 256);
      } else if (array instanceof Uint16Array) {
        array[i] = Math.floor(Math.random() * 65536);
      } else if (array instanceof Uint32Array) {
        array[i] = Math.floor(Math.random() * 4294967296);
      }
    }
    
    return array;
  },
  
  randomUUID: randomUUID,
  
  // Add other crypto methods as needed
  subtle: {
    // Placeholder for SubtleCrypto API
    // Implement specific methods as needed
    digest: async function(algorithm, data) {
      throw new Error('SubtleCrypto.digest is not implemented in this polyfill');
    }
  }
};

// Export the crypto object
export default crypto;

// For compatibility with different import styles
export const getRandomValues = crypto.getRandomValues;
export { randomUUID };

// Add compatibility with CommonJS require
if (typeof module !== 'undefined') {
  module.exports = {
    default: crypto,
    getRandomValues: crypto.getRandomValues,
    randomUUID
  };
}
