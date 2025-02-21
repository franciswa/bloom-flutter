import { useCallback } from 'react';
import { useSharedValue, withSpring, withTiming, Easing, interpolate, useAnimatedStyle } from 'react-native-reanimated';

export type ChartView = 'wheel' | 'table';

interface UseChartViewTransitionResult {
  currentView: ChartView;
  progress: { value: number };
  wheelStyle: ReturnType<typeof useAnimatedStyle>;
  tableStyle: ReturnType<typeof useAnimatedStyle>;
  transitionTo: (view: ChartView) => void;
}

export function useChartViewTransition(initialView: ChartView = 'wheel'): UseChartViewTransitionResult {
  const progress = useSharedValue(initialView === 'wheel' ? 0 : 1);
  const currentView = useSharedValue<ChartView>(initialView);

  const transitionTo = useCallback((view: ChartView) => {
    if (view === currentView.value) return;

    const toValue = view === 'wheel' ? 0 : 1;
    progress.value = withTiming(toValue, {
      duration: 600,
      easing: Easing.bezier(0.4, 0, 0.2, 1),
    });
    currentView.value = view;
  }, [currentView, progress]);

  const wheelStyle = useAnimatedStyle(() => ({
    opacity: interpolate(progress.value, [0, 0.5], [1, 0]),
    transform: [
      { scale: interpolate(progress.value, [0, 1], [1, 0.8]) },
      { rotate: `${interpolate(progress.value, [0, 1], [0, -45])}deg` }
    ]
  }));

  const tableStyle = useAnimatedStyle(() => ({
    opacity: interpolate(progress.value, [0.5, 1], [0, 1]),
    transform: [
      { translateY: interpolate(progress.value, [0, 1], [100, 0]) },
      { scale: interpolate(progress.value, [0, 1], [0.8, 1]) }
    ]
  }));

  return {
    currentView: currentView.value,
    progress,
    wheelStyle,
    tableStyle,
    transitionTo,
  };
}

// Helper hook for managing view state with animations
export function useChartView(initialView: ChartView = 'wheel') {
  const {
    currentView,
    progress,
    wheelStyle,
    tableStyle,
    transitionTo
  } = useChartViewTransition(initialView);

  const toggleView = useCallback(() => {
    transitionTo(currentView === 'wheel' ? 'table' : 'wheel');
  }, [currentView, transitionTo]);

  return {
    currentView,
    progress,
    wheelStyle,
    tableStyle,
    toggleView,
    transitionTo,
  };
}
