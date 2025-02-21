import React, { useState } from 'react';
import { View } from 'react-native';
import { YStack, Text, Button, Input, Label } from 'tamagui';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import { AuthStackParamList } from '../navigation/AuthNavigator';
import { useAuth } from '../hooks/useAuth';

type Props = NativeStackScreenProps<AuthStackParamList, 'ForgotPassword'>;

export default function ForgotPasswordScreen({ navigation }: Props) {
  const { resetPassword } = useAuth();
  const [email, setEmail] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState(false);

  const handleResetPassword = async () => {
    if (!email) {
      setError('Please enter your email address');
      return;
    }

    try {
      setLoading(true);
      setError(null);
      await resetPassword(email);
      setSuccess(true);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to send reset email');
    } finally {
      setLoading(false);
    }
  };

  if (success) {
    return (
      <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
        <YStack space="$4" padding="$4" width="100%" maxWidth={400}>
          <Text
            fontFamily="$heading"
            fontSize="$6"
            textAlign="center"
            marginBottom="$2"
          >
            Check Your Email
          </Text>

          <Text
            fontFamily="$body"
            fontSize="$4"
            textAlign="center"
            color="$textSecondary"
            marginBottom="$6"
          >
            We've sent password reset instructions to your email address.
          </Text>

          <Button
            backgroundColor="$primary"
            color="$background"
            size="$5"
            onPress={() => navigation.navigate('SignIn')}
          >
            Return to Sign In
          </Button>
        </YStack>
      </View>
    );
  }

  return (
    <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
      <YStack space="$4" padding="$4" width="100%" maxWidth={400}>
        <Text
          fontFamily="$heading"
          fontSize="$6"
          textAlign="center"
          marginBottom="$2"
        >
          Reset Password
        </Text>

        <Text
          fontFamily="$body"
          fontSize="$4"
          textAlign="center"
          color="$textSecondary"
          marginBottom="$6"
        >
          Enter your email address and we'll send you instructions to reset your password.
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
          onPress={handleResetPassword}
          disabled={loading}
        >
          {loading ? 'Sending...' : 'Send Reset Instructions'}
        </Button>

        <Button
          variant="outlined"
          size="$5"
          onPress={() => navigation.goBack()}
        >
          Back to Sign In
        </Button>
      </YStack>
    </View>
  );
}
