// Polyfill for AssetDestPathResolver and PackagerAsset types
// This file is used to replace the TypeScript type definitions with JavaScript implementations

// Define the AssetDestPathResolver as a simple string
const AssetDestPathResolver = {
  ANDROID: 'android',
  GENERIC: 'generic'
};

// Asset registry to store assets by ID
const assetRegistry = new Map();

// Function to get an asset by ID
export function getAssetByID(assetId) {
  return assetRegistry.get(assetId);
}

// Function to register an asset
export function registerAsset(asset) {
  const id = asset.id || Math.floor(Math.random() * 1000000);
  assetRegistry.set(id, asset);
  return id;
}

// Define the PackagerAsset as a simple object
class PackagerAsset {
  constructor(asset) {
    this.httpServerLocation = asset.httpServerLocation || '';
    this.name = asset.name || '';
    this.type = asset.type || '';
    this.width = asset.width || 0;
    this.height = asset.height || 0;
    this.scales = asset.scales || [1];
    this.hash = asset.hash || '';
    this.uri = asset.uri || '';
    this.fileSystemLocation = asset.fileSystemLocation || '';
  }

  static fromMetadata(meta) {
    return new PackagerAsset({
      httpServerLocation: meta.httpServerLocation,
      name: meta.name,
      type: meta.type,
      width: meta.width,
      height: meta.height,
      scales: meta.scales,
      hash: meta.hash,
      uri: meta.uri,
      fileSystemLocation: meta.fileSystemLocation
    });
  }

  getScaledAssetPath(scale) {
    const scaleSuffix = scale === 1 ? '' : '@' + scale + 'x';
    return this.httpServerLocation + '/' + this.name + scaleSuffix + '.' + this.type;
  }

  getAssetDestPath(destPathResolver) {
    const scale = this.scales[0] || 1;
    const scaleSuffix = scale === 1 ? '' : '@' + scale + 'x';
    const fileName = this.name + scaleSuffix + '.' + this.type;
    
    if (destPathResolver === AssetDestPathResolver.ANDROID) {
      return 'drawable-' + (scale === 1 ? 'mdpi' : scale === 2 ? 'hdpi' : 'xhdpi') + '/' + fileName;
    }
    
    return fileName;
  }
}

// Export the AssetDestPathResolver and PackagerAsset
export { AssetDestPathResolver, PackagerAsset };
export default { AssetDestPathResolver, PackagerAsset, getAssetByID, registerAsset };

// Add compatibility with CommonJS require
if (typeof module !== 'undefined') {
  module.exports = {
    AssetDestPathResolver,
    PackagerAsset,
    getAssetByID,
    registerAsset,
    default: { AssetDestPathResolver, PackagerAsset, getAssetByID, registerAsset }
  };
}
