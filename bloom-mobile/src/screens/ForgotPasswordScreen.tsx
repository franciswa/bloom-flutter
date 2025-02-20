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

type Props = NativeStackScreenProps<AuthStackParamList, 'ForgotPassword'>;

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

export default function ForgotPasswordScreen({ navigation }: Props) {
  const [email, setEmail] = useState('');
  const [loading, setLoading] = useState(false);

  const handleResetPassword = async () => {
    if (!email) {
      Alert.alert('Error', 'Please enter your email address');
      return;
    }

    try {
      setLoading(true);
      const { error } = await supabase.auth.resetPasswordForEmail(email, {
        redirectTo: 'bloom://reset-password',
      });

      if (error) throw error;

      Alert.alert(
        'Success',
        'Check your email for password reset instructions',
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
      <Title>Reset Password</Title>
      <Description>
        Enter your email address and we'll send you instructions to reset your password.
      </Description>

      <Form space="$4">
        <StyledInput
          placeholder="Email"
          value={email}
          onChangeText={setEmail}
          autoCapitalize="none"
          autoComplete="email"
          keyboardType="email-address"
        />

        <StyledButton
          onPress={handleResetPassword}
          disabled={loading}
        >
          {loading ? 'Sending...' : 'Send Reset Instructions'}
        </StyledButton>
      </Form>
    </Container>
  );
}
