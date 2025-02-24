import React, { useState, useEffect } from 'react';
import { View } from 'react-native';
import { YStack, Text, Button, Input, Label, XStack, Progress } from 'tamagui';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import { AuthStackParamList } from '../navigation/AuthNavigator';
import { supabase } from '../lib/supabase';
import { validatePassword, getPasswordStrengthColor } from '../utils/passwordValidator';

type Props = NativeStackScreenProps<AuthStackParamList, 'ResetPassword'>;

export default function ResetPasswordScreen({ navigation, route }: Props) {
  const { email, token } = route.params;
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState(false);
  const [passwordStrength, setPasswordStrength] = useState<'weak' | 'medium' | 'strong' | undefined>(undefined);
  const [passwordValid, setPasswordValid] = useState(false);

  // Check password strength whenever password changes
  useEffect(() => {
    if (password) {
      const result = validatePassword(password);
      setPasswordStrength(result.strength);
      setPasswordValid(result.isValid);
      if (!result.isValid && result.error) {
        setError(result.error);
      } else {
        setError(null);
      }
    } else {
      setPasswordStrength(undefined);
      setPasswordValid(false);
      setError(null);
    }
  }, [password]);

  const handleResetPassword = async () => {
    if (!password || !confirmPassword) {
      setError('Please fill in all fields');
      return;
    }

    if (password !== confirmPassword) {
      setError('Passwords do not match');
      return;
    }

    // Validate password strength
    const validation = validatePassword(password);
    if (!validation.isValid) {
      setError(validation.error || 'Password does not meet requirements');
      return;
    }

    try {
      setLoading(true);
      setError(null);

      const { error: updateError } = await supabase.auth.updateUser({
        password: password,
      });

      if (updateError) throw updateError;

      setSuccess(true);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to reset password');
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
            Password Reset Complete
          </Text>

          <Text
            fontFamily="$body"
            fontSize="$4"
            textAlign="center"
            color="$textSecondary"
            marginBottom="$6"
          >
            Your password has been successfully reset. You can now sign in with your new password.
          </Text>

          <Button
            backgroundColor="$primary"
            color="$background"
            size="$5"
            onPress={() => navigation.navigate('SignIn')}
          >
            Sign In
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
          Enter your new password below.
        </Text>

        <YStack space="$2">
          <Label htmlFor="password">New Password</Label>
          <Input
            id="password"
            secureTextEntry
            value={password}
            onChangeText={setPassword}
          />
          {password && (
            <YStack space="$1" marginTop="$1">
              <XStack alignItems="center" space="$2">
                <Progress value={passwordStrength === 'weak' ? 33 : passwordStrength === 'medium' ? 66 : passwordStrength === 'strong' ? 100 : 0} size="$1">
                  <Progress.Indicator backgroundColor={getPasswordStrengthColor(passwordStrength)} />
                </Progress>
                {passwordStrength && (
                  <Text fontSize="$2" color={getPasswordStrengthColor(passwordStrength)}>
                    {passwordStrength.charAt(0).toUpperCase() + passwordStrength.slice(1)}
                  </Text>
                )}
              </XStack>
              <Text fontSize="$2" color="$textSecondary">
                Password must contain at least 8 characters, including uppercase, lowercase, 
                numbers, and special characters.
              </Text>
            </YStack>
          )}
        </YStack>

        <YStack space="$2">
          <Label htmlFor="confirmPassword">Confirm New Password</Label>
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
          onPress={handleResetPassword}
          disabled={loading}
        >
          {loading ? 'Resetting...' : 'Reset Password'}
        </Button>

        <Button
          variant="outlined"
          size="$5"
          onPress={() => navigation.navigate('SignIn')}
        >
          Cancel
        </Button>
      </YStack>
    </View>
  );
}
