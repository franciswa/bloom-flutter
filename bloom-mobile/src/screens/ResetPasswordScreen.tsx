import React, { useState } from 'react';
import { Alert } from 'react-native';
import {
  YStack,
  Text,
  H1,
  Form,
  styled,
} from 'tamagui';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import { AuthStackParamList } from '../types/navigation';
import { supabase } from '../lib/supabase';
import { StyledInput, StyledButton } from '../theme/components';

type Props = NativeStackScreenProps<AuthStackParamList, 'ResetPassword'>;

const Container = styled(YStack, {
  flex: 1,
  backgroundColor: '$background',
  padding: '$4',
});

const Title = styled(H1, {
  color: '$text',
  marginBottom: '$2',
  fontFamily: '$heading',
});

const Description = styled(Text, {
  color: '$textSecondary',
  marginBottom: '$6',
  fontFamily: '$body',
});

const ErrorText = styled(Text, {
  color: '$error',
  marginTop: '$2',
  fontFamily: '$body',
});

export default function ResetPasswordScreen({ navigation, route }: Props) {
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const validatePassword = () => {
    if (password.length < 8) {
      setError('Password must be at least 8 characters long');
      return false;
    }
    if (password !== confirmPassword) {
      setError('Passwords do not match');
      return false;
    }
    setError('');
    return true;
  };

  const handleResetPassword = async () => {
    if (!validatePassword()) return;

    try {
      setLoading(true);
      const { error } = await supabase.auth.updateUser({
        password: password,
      });

      if (error) throw error;

      Alert.alert(
        'Success',
        'Your password has been reset successfully',
        [
          {
            text: 'OK',
            onPress: () => navigation.navigate('SignIn'),
          },
        ]
      );
    } catch (error) {
      Alert.alert('Error', (error as Error).message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <Container>
      <Title>Set New Password</Title>
      <Description>
        Please enter your new password below.
      </Description>

      <Form space="$4">
        <StyledInput
          placeholder="New Password"
          value={password}
          onChangeText={setPassword}
          secureTextEntry
          autoCapitalize="none"
          autoComplete="password-new"
        />

        <StyledInput
          placeholder="Confirm Password"
          value={confirmPassword}
          onChangeText={setConfirmPassword}
          secureTextEntry
          autoCapitalize="none"
          autoComplete="password-new"
        />

        {error ? <ErrorText>{error}</ErrorText> : null}

        <StyledButton
          onPress={handleResetPassword}
          disabled={loading}
          marginTop="$4"
        >
          {loading ? 'Updating...' : 'Update Password'}
        </StyledButton>
      </Form>
    </Container>
  );
}
