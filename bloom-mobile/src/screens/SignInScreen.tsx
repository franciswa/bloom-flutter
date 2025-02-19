import React, { useState } from 'react';
import {
  YStack,
  Text,
  H1,
  Button,
  Input,
  Form,
  styled,
} from 'tamagui';
import { Alert } from 'react-native';
import { useAuth } from '../hooks/useAuth';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import { AuthStackParamList } from '../navigation/AuthNavigator';

type Props = NativeStackScreenProps<AuthStackParamList, 'SignIn'>;

const Container = styled(YStack, {
  flex: 1,
  backgroundColor: '$background',
  padding: '$4',
});

const Header = styled(YStack, {
  paddingVertical: '$5',
});

const HeaderTitle = styled(H1, {
  color: '$text',
  fontFamily: '$heading',
});

const SubText = styled(Text, {
  color: '$gray11',
  textAlign: 'center',
  marginTop: '$2',
});

const FormContainer = styled(Form, {
  space: '$4',
  marginTop: '$6',
});

const SignUpLink = styled(Text, {
  color: '$primary',
  textAlign: 'center',
  marginTop: '$4',
});

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
      <Header>
        <HeaderTitle>Welcome Back</HeaderTitle>
        <SubText>Sign in to continue your journey</SubText>
      </Header>

      <FormContainer>
        <Input
          placeholder="Email"
          value={email}
          onChangeText={setEmail}
          autoCapitalize="none"
          keyboardType="email-address"
        />
        <Input
          placeholder="Password"
          value={password}
          onChangeText={setPassword}
          secureTextEntry
        />
        <Button
          marginTop="$4"
          onPress={handleSubmit}
          disabled={loading}
        >
          Sign In
        </Button>
      </FormContainer>

      <SignUpLink onPress={() => navigation.navigate('SignUp')}>
        Don't have an account? Sign up
      </SignUpLink>
    </Container>
  );
}
