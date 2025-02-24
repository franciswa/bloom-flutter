import React from 'react';
import { View } from 'react-native';
import { YStack, Text, Button } from 'tamagui';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import { AuthStackParamList } from '../navigation/AuthNavigator';

type Props = NativeStackScreenProps<AuthStackParamList, 'Welcome'>;

export default function WelcomeScreen({ navigation }: Props) {
  return (
    <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
      <YStack space="$4" padding="$4">
        <Text
          fontFamily="$heading"
          fontSize="$8"
          textAlign="center"
          marginBottom="$4"
        >
          Welcome to Bloom
        </Text>
        
        <Text
          fontFamily="$body"
          fontSize="$4"
          textAlign="center"
          color="$textSecondary"
          marginBottom="$6"
        >
          Find your perfect match through the power of astrology
        </Text>
        
        <Button
          size="$5"
          backgroundColor="$primary"
          color="$background"
          onPress={() => navigation.navigate('SignIn')}
        >
          Sign In
        </Button>
        
        <Button
          size="$5"
          backgroundColor="$background"
          borderColor="$primary"
          borderWidth={1}
          onPress={() => navigation.navigate('SignUp')}
        >
          Create Account
        </Button>
      </YStack>
    </View>
  );
}
