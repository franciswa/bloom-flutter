import { useCallback } from 'react';
import { useSharedValue, withSpring, withTiming, withSequence } from 'react-native-reanimated';
import { Gesture, PinchGestureHandlerEventPayload, RotationGestureHandlerEventPayload, PanGestureHandlerEventPayload } from 'react-native-gesture-handler';
import { Planet } from '../types/chart';

interface Point {
  x: number;
  y: number;
}

export function useChartInteractions(onPlanetSelect?: (planet: Planet | null) => void) {
  // Shared values for animations
  const selectedPlanet = useSharedValue<Planet | null>(null);
  const scale = useSharedValue(1);
  const rotation = useSharedValue(0);
  const pan = useSharedValue({ x: 0, y: 0 });

  // Planet selection animation
  const planetHighlight = useCallback((planetId: Planet) => {
    selectedPlanet.value = planetId;
    onPlanetSelect?.(planetId);
    return withSequence(
      withSpring(1.2, { damping: 12, stiffness: 100 }), // Scale up
      withSpring(1.1, { damping: 15, stiffness: 90 })   // Settle slightly larger
    );
  }, [selectedPlanet, onPlanetSelect]);

  // Reset planet selection
  const resetPlanetHighlight = useCallback(() => {
    selectedPlanet.value = null;
    onPlanetSelect?.(null);
    return withSpring(1, { damping: 15, stiffness: 90 });
  }, [selectedPlanet, onPlanetSelect]);

  // Pinch to zoom gesture
  const pinchGesture = Gesture.Pinch()
    .onUpdate((e: PinchGestureHandlerEventPayload) => {
      const newScale = scale.value * e.scale;
      scale.value = Math.min(Math.max(newScale, 0.5), 3); // Clamp between 0.5x and 3x
    })
    .onEnd(() => {
      // Snap to reasonable bounds if too small/large
      if (scale.value < 0.7) {
        scale.value = withSpring(0.7);
      } else if (scale.value > 2.5) {
        scale.value = withSpring(2.5);
      }
    });

  // Pan gesture
  const panGesture = Gesture.Pan()
    .minDistance(10)
    .onUpdate((e: PanGestureHandlerEventPayload) => {
      pan.value = {
        x: pan.value.x + e.translationX,
        y: pan.value.y + e.translationY
      };
    })
    .onEnd(() => {
      // Optional: Add bounds checking and spring back if needed
      const maxPan = 150 * scale.value;
      if (Math.abs(pan.value.x) > maxPan || Math.abs(pan.value.y) > maxPan) {
        pan.value = {
          x: withSpring(Math.min(Math.max(pan.value.x, -maxPan), maxPan)),
          y: withSpring(Math.min(Math.max(pan.value.y, -maxPan), maxPan))
        };
      }
    });

  // Rotation gesture with house snapping
  const rotationGesture = Gesture.Rotation()
    .onUpdate((e: RotationGestureHandlerEventPayload) => {
      rotation.value = e.rotation;
    })
    .onEnd(() => {
      // Snap to nearest house (30° segments)
      const snapRotation = Math.round(rotation.value / (Math.PI / 6)) * (Math.PI / 6);
      rotation.value = withSpring(snapRotation, {
        damping: 15,
        stiffness: 90,
      });
    });

  // Compose gestures
  const chartGestures = Gesture.Simultaneous(
    pinchGesture,
    panGesture,
    rotationGesture
  );

  // Reset all transformations
  const resetTransforms = useCallback(() => {
    scale.value = withSpring(1);
    rotation.value = withSpring(0);
    pan.value = {
      x: withSpring(0),
      y: withSpring(0)
    };
    selectedPlanet.value = null;
    onPlanetSelect?.(null);
  }, [scale, rotation, pan, selectedPlanet, onPlanetSelect]);

  return {
    // Shared values
    selectedPlanet,
    scale,
    rotation,
    pan,
    
    // Animation functions
    planetHighlight,
    resetPlanetHighlight,
    resetTransforms,
    
    // Gestures
    chartGestures,
    
    // Individual gestures if needed
    pinchGesture,
    panGesture,
    rotationGesture,
  };
}
