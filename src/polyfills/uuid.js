import sha1 from 'expo-modules-core/build/uuid/lib/sha1';
import v35 from 'expo-modules-core/build/uuid/lib/v35';
import { Uuidv5Namespace } from 'expo-modules-core/build/uuid/uuid.types';

function uuidv4() {
  if (typeof window !== 'undefined' && window.crypto) {
    if (window.crypto.randomUUID) {
      return window.crypto.randomUUID();
    }
    
    // Fallback implementation using crypto.getRandomValues
    const rnds8 = new Uint8Array(16);
    window.crypto.getRandomValues(rnds8);
    
    // Set version (4) and variant (RFC4122)
    rnds8[6] = (rnds8[6] & 0x0f) | 0x40;
    rnds8[8] = (rnds8[8] & 0x3f) | 0x80;
    
    // Convert to hex string
    return Array.from(rnds8)
      .map(b => b.toString(16).padStart(2, '0'))
      .join('')
      .replace(/^(.{8})(.{4})(.{4})(.{4})(.{12})$/, '$1-$2-$3-$4-$5');
  }
  
  // Final fallback using Math.random
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
    const r = Math.random() * 16 | 0;
    const v = c === 'x' ? r : (r & 0x3 | 0x8);
    return v.toString(16);
  });
}

const uuid = {
  v4: uuidv4,
  v5: v35('v5', 0x50, sha1),
  namespace: Uuidv5Namespace,
};

export default uuid;
