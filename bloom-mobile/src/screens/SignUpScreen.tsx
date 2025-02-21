import React, { useState } from 'react';
import { View } from 'react-native';
import { YStack, Text, Button, Input, Label } from 'tamagui';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import { AuthStackParamList } from '../navigation/AuthNavigator';
import { useAuth } from '../hooks/useAuth';

type Props = NativeStackScreenProps<AuthStackParamList, 'SignUp'>;

export default function SignUpScreen({ navigation }: Props) {
  const { signUp } = useAuth();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleSignUp = async () => {
    if (!email || !password || !confirmPassword) {
      setError('Please fill in all fields');
      return;
    }

    if (password !== confirmPassword) {
      setError('Passwords do not match');
      return;
    }

    if (password.length < 8) {
      setError('Password must be at least 8 characters long');
      return;
    }

    try {
      setLoading(true);
      setError(null);
      await signUp(email, password);
      // Note: User will need to verify their email before signing in
      navigation.navigate('SignIn');
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to sign up');
    } finally {
      setLoading(false);
    }
  };

  return (
    <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
      <YStack space="$4" padding="$4" width="100%" maxWidth={400}>
        <Text
          fontFamily="$heading"
          fontSize="$8"
          textAlign="center"
          marginBottom="$4"
        >
          Create Account
        </Text>

        <YStack space="$2">
          <Label htmlFor="email">Email</Label>
          <Input
            id="email"
            autoCapitalize="none"
            keyboardType="email-address"
            value={email}
            onChangeText={setEmail}
          />
        </YStack>

        <YStack space="$2">
          <Label htmlFor="password">Password</Label>
          <Input
            id="password"
            secureTextEntry
            value={password}
            onChangeText={setPassword}
          />
        </YStack>

        <YStack space="$2">
          <Label htmlFor="confirmPassword">Confirm Password</Label>
          <Input
            id="confirmPassword"
            secureTextEntry
            value={confirmPassword}
            onChangeText={setConfirmPassword}
          />
        </YStack>

        {error && (
          <Text
            color="$red10"
            textAlign="center"
            marginTop="$2"
          >
            {error}
          </Text>
        )}

        <Button
          marginTop="$4"
          backgroundColor="$primary"
          color="$background"
          size="$5"
          onPress={handleSignUp}
          disabled={loading}
        >
          {loading ? 'Creating account...' : 'Create Account'}
        </Button>

        <YStack alignItems="center" marginTop="$4">
          <Text color="$textSecondary">
            Already have an account?{' '}
            <Text
              color="$primary"
              onPress={() => navigation.navigate('SignIn')}
            >
              Sign In
            </Text>
          </Text>
        </YStack>
      </YStack>
    </View>
  );
}
