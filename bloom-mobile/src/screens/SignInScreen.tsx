import React, { useState } from 'react';
import { Alert } from 'react-native';
import { useAuth } from '../hooks/useAuth';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import { AuthStackParamList } from '../navigation/AuthNavigator';
import {
  Container,
  Title,
  Subtitle,
  StyledInput,
  StyledButton,
  BodyText,
} from '../theme/components';

type Props = NativeStackScreenProps<AuthStackParamList, 'SignIn'>;

export default function SignInScreen({ navigation }: Props) {
  const { signIn, loading } = useAuth();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');

  const handleSubmit = async () => {
    if (!email || !password) {
      Alert.alert('Error', 'Please fill in all fields');
      return;
    }

    try {
      await signIn({
        email,
        password,
      });
    } catch (err) {
      Alert.alert('Error', err instanceof Error ? err.message : 'Failed to sign in');
    }
  };

  return (
    <Container>
      <Title textAlign="center">Welcome Back</Title>
      <Subtitle textAlign="center">Sign in to continue your journey</Subtitle>

      <StyledInput
        marginTop="$6"
        placeholder="Email"
        value={email}
        onChangeText={setEmail}
        autoCapitalize="none"
        keyboardType="email-address"
      />
      
      <StyledInput
        marginTop="$3"
        placeholder="Password"
        value={password}
        onChangeText={setPassword}
        secureTextEntry
      />

      <StyledButton
        marginTop="$4"
        onPress={handleSubmit}
        disabled={loading}
        variant="primary"
      >
        {loading ? 'Signing In...' : 'Sign In'}
      </StyledButton>

      <BodyText
        marginTop="$4"
        textAlign="center"
        onPress={() => navigation.navigate('SignUp')}
      >
        Don't have an account?{' '}
        <BodyText
          color="$primary"
          fontWeight="600"
        >
          Sign up
        </BodyText>
      </BodyText>
    </Container>
  );
}
