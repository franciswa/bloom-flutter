// Use the browser's native crypto API
const crypto = {
  randomUUID: () => {
    if (typeof window !== 'undefined' && window.crypto) {
      return window.crypto.randomUUID();
    }
    // Fallback for environments without crypto.randomUUID
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) => {
      const r = (Math.random() * 16) | 0;
      const v = c === 'x' ? r : (r & 0x3) | 0x8;
      return v.toString(16);
    });
  },
  // Add other crypto methods if needed
};

module.exports = crypto;
