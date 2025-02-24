import React, { useState, useEffect } from 'react';
import { Image, ImageProps, View, StyleSheet, ActivityIndicator, LayoutChangeEvent } from 'react-native';
import { getOptimalImageSize } from '../utils/imageOptimizer';
import * as FileSystem from 'expo-file-system';

interface ProfileImage {
  thumbnail: string;
  profile: string;
  full: string;
}

interface OptimizedProfileImageProps extends Omit<ImageProps, 'source'> {
  /**
   * Image URLs for different sizes (thumbnail, profile, full)
   */
  images: ProfileImage;
  
  /**
   * Default placeholder while loading
   */
  placeholderSource?: any;
  
  /**
   * Whether to cache the image locally
   */
  cacheLocally?: boolean;
  
  /**
   * Whether to show loading indicator
   */
  showLoading?: boolean;
}

export default function OptimizedProfileImage({
  images,
  placeholderSource,
  cacheLocally = true,
  showLoading = true,
  style,
  onLoad,
  ...props
}: OptimizedProfileImageProps) {
  const [containerSize, setContainerSize] = useState({ width: 0, height: 0 });
  const [loading, setLoading] = useState(true);
  const [imageSource, setImageSource] = useState<any>(placeholderSource || null);
  const [cachedUri, setCachedUri] = useState<string | null>(null);

  // Handle layout change to get container dimensions
  const onLayout = (event: LayoutChangeEvent) => {
    const { width, height } = event.nativeEvent.layout;
    setContainerSize({ width, height });
  };

  // Determine the optimal image size based on container dimensions
  useEffect(() => {
    if (containerSize.width === 0 || containerSize.height === 0) return;
    
    const loadImage = async () => {
      try {
        setLoading(true);
        
        // Get the optimal image size
        const sizeKey = getOptimalImageSize(containerSize.width, containerSize.height);
        const imageUrl = images[sizeKey];
        
        if (!imageUrl) {
          throw new Error('Image URL not found');
        }

        // Check if we should cache the image locally
        if (cacheLocally) {
          // Create a unique filename based on the URL
          const filename = imageUrl.split('/').pop() || 'image.jpg';
          const cacheDirectory = `${FileSystem.cacheDirectory}profile_images/`;
          const cachedPath = `${cacheDirectory}${filename}`;
          
          // Check if directory exists, create if not
          const dirInfo = await FileSystem.getInfoAsync(cacheDirectory);
          if (!dirInfo.exists) {
            await FileSystem.makeDirectoryAsync(cacheDirectory, { intermediates: true });
          }
          
          // Check if file already exists in cache
          const fileInfo = await FileSystem.getInfoAsync(cachedPath);
          
          if (fileInfo.exists) {
            // Use cached file
            setCachedUri(cachedPath);
            setImageSource({ uri: cachedPath });
          } else {
            // Download and cache the file
            const downloadResult = await FileSystem.downloadAsync(
              imageUrl, 
              cachedPath
            );
            
            if (downloadResult.status === 200) {
              setCachedUri(cachedPath);
              setImageSource({ uri: cachedPath });
            } else {
              // Fallback to direct URL if download fails
              setImageSource({ uri: imageUrl });
            }
          }
        } else {
          // Use the URL directly without caching
          setImageSource({ uri: imageUrl });
        }
      } catch (error) {
        console.error('Error loading image:', error);
        // Use the smallest available image as fallback
        if (images.thumbnail) {
          setImageSource({ uri: images.thumbnail });
        }
      } finally {
        setLoading(false);
      }
    };

    loadImage();
  }, [containerSize, images, cacheLocally]);

  // Clean up cached image when component unmounts
  useEffect(() => {
    return () => {
      // Optionally clear the cached image when component unmounts
      // This is useful for temporary images that won't be reused
      if (cachedUri && !cacheLocally) {
        FileSystem.deleteAsync(cachedUri, { idempotent: true }).catch(e => {
          console.log('Failed to delete cached image:', e);
        });
      }
    };
  }, [cachedUri, cacheLocally]);

  return (
    <View style={[styles.container, style]} onLayout={onLayout}>
      {imageSource && (
        <Image
          source={imageSource}
          style={styles.image}
          onLoad={(e) => {
            setLoading(false);
            onLoad && onLoad(e);
          }}
          {...props}
        />
      )}
      
      {(loading && showLoading) && (
        <View style={styles.loadingContainer}>
          <ActivityIndicator size="small" color="#0000ff" />
        </View>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    position: 'relative',
    overflow: 'hidden',
  },
  image: {
    width: '100%',
    height: '100%',
  },
  loadingContainer: {
    ...StyleSheet.absoluteFillObject,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: 'rgba(0,0,0,0.1)',
  },
});