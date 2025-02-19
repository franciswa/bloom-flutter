import React, { useState } from 'react';
import {
  YStack,
  XStack,
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

type Props = NativeStackScreenProps<AuthStackParamList, 'SignUp'>;

type Step = 'credentials' | 'birth-info' | 'location';

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

const StepIndicator = styled(XStack, {
  justifyContent: 'center',
  marginTop: '$4',
  space: '$4',
});

const StepDot = styled(YStack, {
  width: 10,
  height: 10,
  borderRadius: 5,
  backgroundColor: '$gray8',
  variants: {
    active: {
      true: {
        backgroundColor: '$primary',
      },
    },
  },
});

const FormContainer = styled(Form, {
  space: '$4',
  marginTop: '$6',
});

const ButtonContainer = styled(XStack, {
  justifyContent: 'space-between',
  marginTop: '$6',
});

export default function SignUpScreen({ navigation }: Props) {
  const { signUp, loading } = useAuth();
  const [currentStep, setCurrentStep] = useState<Step>('credentials');
  
  // Form state
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [birthDate, setBirthDate] = useState('');
  const [birthTime, setBirthTime] = useState('');
  const [city, setCity] = useState('');
  const [latitude, setLatitude] = useState('');
  const [longitude, setLongitude] = useState('');

  const handleNext = () => {
    if (currentStep === 'credentials') {
      if (!email || !password || !confirmPassword) {
        Alert.alert('Error', 'Please fill in all fields');
        return;
      }
      if (password !== confirmPassword) {
        Alert.alert('Error', 'Passwords do not match');
        return;
      }
      setCurrentStep('birth-info');
    } else if (currentStep === 'birth-info') {
      if (!birthDate || !birthTime) {
        Alert.alert('Error', 'Please fill in all fields');
        return;
      }
      setCurrentStep('location');
    }
  };

  const handleBack = () => {
    if (currentStep === 'birth-info') {
      setCurrentStep('credentials');
    } else if (currentStep === 'location') {
      setCurrentStep('birth-info');
    }
  };

  const handleSubmit = async () => {
    if (!city || !latitude || !longitude) {
      Alert.alert('Error', 'Please fill in all fields');
      return;
    }

    try {
      await signUp({
        email,
        password,
        birthDate,
        birthTime,
        birthLocation: {
          city,
          latitude: parseFloat(latitude),
          longitude: parseFloat(longitude),
        },
      });
    } catch (err) {
      Alert.alert('Error', err instanceof Error ? err.message : 'Failed to sign up');
    }
  };

  return (
    <Container>
      <Header>
        <HeaderTitle>Create Account</HeaderTitle>
        <StepIndicator>
          <StepDot active={currentStep === 'credentials'} />
          <StepDot active={currentStep === 'birth-info'} />
          <StepDot active={currentStep === 'location'} />
        </StepIndicator>
      </Header>

      {currentStep === 'credentials' && (
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
          <Input
            placeholder="Confirm Password"
            value={confirmPassword}
            onChangeText={setConfirmPassword}
            secureTextEntry
          />
          <ButtonContainer>
            <Button
              flex={1}
              variant="outlined"
              disabled={true}
              opacity={0}
            >
              Back
            </Button>
            <Button
              flex={1}
              marginLeft="$4"
              onPress={handleNext}
              disabled={loading}
            >
              Next
            </Button>
          </ButtonContainer>
        </FormContainer>
      )}

      {currentStep === 'birth-info' && (
        <FormContainer>
          <Input
            placeholder="Birth Date (YYYY-MM-DD)"
            value={birthDate}
            onChangeText={setBirthDate}
          />
          <Input
            placeholder="Birth Time (HH:mm)"
            value={birthTime}
            onChangeText={setBirthTime}
          />
          <ButtonContainer>
            <Button
              flex={1}
              variant="outlined"
              onPress={handleBack}
              disabled={loading}
            >
              Back
            </Button>
            <Button
              flex={1}
              marginLeft="$4"
              onPress={handleNext}
              disabled={loading}
            >
              Next
            </Button>
          </ButtonContainer>
        </FormContainer>
      )}

      {currentStep === 'location' && (
        <FormContainer>
          <Input
            placeholder="City"
            value={city}
            onChangeText={setCity}
          />
          <Input
            placeholder="Latitude"
            value={latitude}
            onChangeText={setLatitude}
            keyboardType="numeric"
          />
          <Input
            placeholder="Longitude"
            value={longitude}
            onChangeText={setLongitude}
            keyboardType="numeric"
          />
          <ButtonContainer>
            <Button
              flex={1}
              variant="outlined"
              onPress={handleBack}
              disabled={loading}
            >
              Back
            </Button>
            <Button
              flex={1}
              marginLeft="$4"
              onPress={handleSubmit}
              disabled={loading}
            >
              Sign Up
            </Button>
          </ButtonContainer>
        </FormContainer>
      )}
    </Container>
  );
}
