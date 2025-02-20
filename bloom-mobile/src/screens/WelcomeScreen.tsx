import React from 'react';
import {
  YStack,
  Text,
  H1,
  styled,
} from 'tamagui';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import { AuthStackParamList } from '../types/navigation';
import { StyledButton } from '../theme/components';

type Props = NativeStackScreenProps<AuthStackParamList, 'Welcome'>;

const Container = styled(YStack, {
  flex: 1,
  backgroundColor: '$background',
  padding: '$4',
  justifyContent: 'space-between',
});

const Header = styled(YStack, {
  alignItems: 'center',
  marginTop: '$8',
});

const Title = styled(H1, {
  color: '$text',
  marginBottom: '$2',
  fontFamily: '$heading',
  textAlign: 'center',
});

const Subtitle = styled(Text, {
  color: '$textSecondary',
  fontSize: '$4',
  marginBottom: '$6',
  fontFamily: '$body',
  textAlign: 'center',
});

const ButtonContainer = styled(YStack, {
  space: '$4',
  marginBottom: '$8',
});

export default function WelcomeScreen({ navigation }: Props) {
  return (
    <Container>
      <Header>
        <Title>Welcome to Bloom</Title>
        <Subtitle>
          Find your perfect match based on astrology and shared values
        </Subtitle>
      </Header>

      <ButtonContainer>
        <StyledButton
          variant="primary"
          size="large"
          onPress={() => navigation.navigate('SignUp')}
        >
          Create Account
        </StyledButton>

        <StyledButton
          variant="outline"
          size="large"
          onPress={() => navigation.navigate('SignIn')}
        >
          Sign In
        </StyledButton>
      </ButtonContainer>
    </Container>
  );
}
