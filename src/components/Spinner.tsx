import React from 'react';
import { ActivityIndicator } from 'react-native';

type SpinnerProps = {
  size?: number;
  color?: string;
};

export const Spinner = ({ size = 20, color = '#000000' }: SpinnerProps) => {
  return <ActivityIndicator size={size} color={color} />;
};
