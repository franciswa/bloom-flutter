import React from 'react'
import { Ionicons } from '@expo/vector-icons'
import { TabParamList } from '../types/navigation'
import { styled } from 'tamagui'
import { View } from 'tamagui'

export interface TabBarIconProps {
  name: keyof TabParamList
  focused: boolean
  size: number
  color: string
}

const iconMap: Record<keyof TabParamList, keyof typeof Ionicons.glyphMap> = {
  Matches: 'heart',
  Chat: 'chatbubbles',
  Date: 'calendar',
  Profile: 'person',
  Settings: 'settings',
  Notifications: 'notifications'
}

const AnimatedIcon = styled(View, {
  alignItems: 'center',
  justifyContent: 'center',
  animation: 'quick',
  pressStyle: {
    scale: 0.9,
  },
  variants: {
    focused: {
      true: {
        scale: 1.1,
      },
    },
  },
})

export default function TabBarIcon({ name, focused, color, size }: TabBarIconProps) {
  const iconName = iconMap[name]
  const fullIconName = focused ? iconName : `${iconName}-outline`
  
  return (
    <AnimatedIcon focused={focused}>
      <Ionicons 
        name={fullIconName as keyof typeof Ionicons.glyphMap} 
        size={size} 
        color={color}
      />
    </AnimatedIcon>
  )
}
