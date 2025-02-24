import { useCallback, useState } from 'react';
import { useSharedValue, withSpring, runOnJS } from 'react-native-reanimated';
import { Gesture, PanGestureHandlerEventPayload } from 'react-native-gesture-handler';
import { ZodiacSign, ZODIAC_SIGNS } from '../types/chart';
import * as Haptics from 'expo-haptics';

export function useZodiacSelector(onSelectSign: (sign: ZodiacSign) => void) {
  // Current rotation in radians
  const rotation = useSharedValue(0);
  
  // Currently selected sign
  const [selectedSign, setSelectedSign] = useState<ZodiacSign>('aries');

  // Convert rotation to zodiac sign
  const getSignFromRotation = useCallback((rotation: number) => {
    // Normalize rotation to 0-360 degrees
    const degrees = ((rotation * 180 / Math.PI) % 360 + 360) % 360;
    // Each sign takes up 30 degrees
    const signIndex = Math.floor(degrees / 30);
    // Map index to sign
    const signs = Object.keys(ZODIAC_SIGNS) as ZodiacSign[];
    return signs[signIndex];
  }, []);

  // Update selected sign and trigger haptic feedback
  const updateSelectedSign = useCallback((newRotation: number) => {
    const newSign = getSignFromRotation(newRotation);
    if (newSign !== selectedSign) {
      setSelectedSign(newSign);
      Haptics.selectionAsync(); // Light haptic feedback
    }
  }, [selectedSign, getSignFromRotation]);

  // Rotation gesture
  const rotationGesture = Gesture.Pan()
    .onUpdate((e) => {
      // Convert pan gesture to rotation
      const newRotation = rotation.value + (e.translationX / 200); // Adjust sensitivity
      rotation.value = newRotation;
      runOnJS(updateSelectedSign)(newRotation);
    })
    .onEnd(() => {
      // Snap to nearest sign (30° segments)
      const snapRotation = Math.round(rotation.value / (Math.PI / 6)) * (Math.PI / 6);
      rotation.value = withSpring(snapRotation, {
        damping: 15,
        stiffness: 90,
      });
      runOnJS(updateSelectedSign)(snapRotation);
    });

  // Handle selection confirmation
  const handleSelect = useCallback(() => {
    Haptics.notificationAsync(Haptics.NotificationFeedbackType.Success);
    onSelectSign(selectedSign);
  }, [selectedSign, onSelectSign]);

  return {
    rotation,
    selectedSign,
    rotationGesture,
    handleSelect,
  };
}
