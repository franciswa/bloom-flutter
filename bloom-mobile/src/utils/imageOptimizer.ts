import * as ImageManipulator from 'expo-image-manipulator';
import * as FileSystem from 'expo-file-system';

export interface OptimizedImage {
  uri: string;
  width: number;
  height: number;
  size: number; // in bytes
}

/**
 * Image quality levels
 * - high: 0.9 (minimal compression, good for detailed images)
 * - medium: 0.7 (balanced compression)
 * - low: 0.5 (heavier compression, smaller file size)
 */
export type ImageQuality = 'high' | 'medium' | 'low';

/**
 * Quality factor mappings
 */
const QUALITY_FACTORS = {
  high: 0.9,
  medium: 0.7,
  low: 0.5,
};

/**
 * Maximum dimensions for different profile image sizes
 */
export const IMAGE_SIZES = {
  thumbnail: { width: 150, height: 150 },
  profile: { width: 500, height: 500 },
  full: { width: 1080, height: 1080 },
};

/**
 * Optimizes an image by resizing and compressing it
 * @param imageUri URI of the image to optimize
 * @param maxWidth Maximum width of the resulting image
 * @param maxHeight Maximum height of the resulting image
 * @param quality Quality level of the compression
 * @returns Promise with the optimized image info
 */
export async function optimizeImage(
  imageUri: string,
  maxWidth: number = IMAGE_SIZES.profile.width,
  maxHeight: number = IMAGE_SIZES.profile.height,
  quality: ImageQuality = 'medium'
): Promise<OptimizedImage> {
  try {
    // Step 1: Resize the image maintaining aspect ratio
    const resizeResult = await ImageManipulator.manipulateAsync(
      imageUri,
      [{ resize: { width: maxWidth, height: maxHeight } }],
      { 
        compress: QUALITY_FACTORS[quality],
        format: ImageManipulator.SaveFormat.JPEG 
      }
    );

    // Step 2: Get the file info
    const fileInfo = await FileSystem.getInfoAsync(resizeResult.uri);

    // Return the optimized image info
    return {
      uri: resizeResult.uri,
      width: resizeResult.width,
      height: resizeResult.height,
      size: fileInfo.size || 0,
    };
  } catch (error) {
    console.error('Image optimization failed:', error);
    // Return the original image if optimization fails
    return {
      uri: imageUri,
      width: 0,
      height: 0,
      size: 0,
    };
  }
}

/**
 * Creates different sizes of profile images for efficient loading
 * @param imageUri URI of the original image
 * @returns Promise with different sized versions of the image
 */
export async function createProfileImageSizes(
  imageUri: string
): Promise<{
  thumbnail: OptimizedImage;
  profile: OptimizedImage;
  full: OptimizedImage;
}> {
  // Generate all sizes concurrently
  const [thumbnail, profile, full] = await Promise.all([
    optimizeImage(
      imageUri,
      IMAGE_SIZES.thumbnail.width,
      IMAGE_SIZES.thumbnail.height,
      'medium'
    ),
    optimizeImage(
      imageUri,
      IMAGE_SIZES.profile.width, 
      IMAGE_SIZES.profile.height,
      'high'
    ),
    optimizeImage(
      imageUri,
      IMAGE_SIZES.full.width,
      IMAGE_SIZES.full.height,
      'high'
    ),
  ]);

  return {
    thumbnail,
    profile,
    full,
  };
}

/**
 * Gets the appropriate image size based on the container dimensions
 * @param availableWidth Width of the container
 * @param availableHeight Height of the container
 * @returns The optimal image size key
 */
export function getOptimalImageSize(
  availableWidth: number,
  availableHeight: number
): 'thumbnail' | 'profile' | 'full' {
  const maxDimension = Math.max(availableWidth, availableHeight);
  
  if (maxDimension <= 150) {
    return 'thumbnail';
  } else if (maxDimension <= 500) {
    return 'profile';
  } else {
    return 'full';
  }
}