import React, { useState } from 'react';
import { View } from 'react-native';
import { YStack, Text, Button, Input, Label } from 'tamagui';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import { AuthStackParamList } from '../navigation/AuthNavigator';
import { useAuth } from '../hooks/useAuth';

type Props = NativeStackScreenProps<AuthStackParamList, 'SignIn'>;

export default function SignInScreen({ navigation }: Props) {
  const { signIn } = useAuth();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const handleSignIn = async () => {
    if (!email || !password) {
      setError('Please enter both email and password');
      return;
    }

    try {
      setLoading(true);
      setError(null);
      await signIn(email, password);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to sign in');
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
          Sign In
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
          onPress={handleSignIn}
          disabled={loading}
        >
          {loading ? 'Signing in...' : 'Sign In'}
        </Button>

        <Button
          variant="outlined"
          size="$5"
          onPress={() => navigation.navigate('ForgotPassword')}
        >
          Forgot Password?
        </Button>

        <YStack alignItems="center" marginTop="$4">
          <Text color="$textSecondary">
            Don't have an account?{' '}
            <Text
              color="$primary"
              onPress={() => navigation.navigate('SignUp')}
            >
              Sign Up
            </Text>
          </Text>
        </YStack>
      </YStack>
    </View>
  );
}
