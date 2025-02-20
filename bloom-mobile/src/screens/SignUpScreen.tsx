import React, { useState } from 'react';
import { Alert } from 'react-native';
import { useAuth } from '../hooks/useAuth';
import { NativeStackScreenProps } from '@react-navigation/native-stack';
import { AuthStackParamList } from '../navigation/AuthNavigator';
import {
  Container,
  Title,
  StyledInput,
  StyledButton,
  StepIndicator,
  StepDot,
  FormContainer,
  ButtonContainer,
} from '../theme/components';

type Props = NativeStackScreenProps<AuthStackParamList, 'SignUp'>;

type Step = 'credentials' | 'birth-info' | 'location';

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
      <Title textAlign="center">Create Account</Title>
      <StepIndicator>
        <StepDot active={currentStep === 'credentials'} />
        <StepDot active={currentStep === 'birth-info'} />
        <StepDot active={currentStep === 'location'} />
      </StepIndicator>

      {currentStep === 'credentials' && (
        <FormContainer>
          <StyledInput
            placeholder="Email"
            value={email}
            onChangeText={setEmail}
            autoCapitalize="none"
            keyboardType="email-address"
          />
          <StyledInput
            placeholder="Password"
            value={password}
            onChangeText={setPassword}
            secureTextEntry
          />
          <StyledInput
            placeholder="Confirm Password"
            value={confirmPassword}
            onChangeText={setConfirmPassword}
            secureTextEntry
          />
          <ButtonContainer>
            <StyledButton
              flex={1}
              variant="outline"
              disabled={true}
              opacity={0}
            >
              Back
            </StyledButton>
            <StyledButton
              flex={1}
              onPress={handleNext}
              disabled={loading}
            >
              Next
            </StyledButton>
          </ButtonContainer>
        </FormContainer>
      )}

      {currentStep === 'birth-info' && (
        <FormContainer>
          <StyledInput
            placeholder="Birth Date (YYYY-MM-DD)"
            value={birthDate}
            onChangeText={setBirthDate}
          />
          <StyledInput
            placeholder="Birth Time (HH:mm)"
            value={birthTime}
            onChangeText={setBirthTime}
          />
          <ButtonContainer>
            <StyledButton
              flex={1}
              variant="outline"
              onPress={handleBack}
              disabled={loading}
            >
              Back
            </StyledButton>
            <StyledButton
              flex={1}
              onPress={handleNext}
              disabled={loading}
            >
              Next
            </StyledButton>
          </ButtonContainer>
        </FormContainer>
      )}

      {currentStep === 'location' && (
        <FormContainer>
          <StyledInput
            placeholder="City"
            value={city}
            onChangeText={setCity}
          />
          <StyledInput
            placeholder="Latitude"
            value={latitude}
            onChangeText={setLatitude}
            keyboardType="numeric"
          />
          <StyledInput
            placeholder="Longitude"
            value={longitude}
            onChangeText={setLongitude}
            keyboardType="numeric"
          />
          <ButtonContainer>
            <StyledButton
              flex={1}
              variant="outline"
              onPress={handleBack}
              disabled={loading}
            >
              Back
            </StyledButton>
            <StyledButton
              flex={1}
              onPress={handleSubmit}
              disabled={loading}
            >
              {loading ? 'Creating Account...' : 'Sign Up'}
            </StyledButton>
          </ButtonContainer>
        </FormContainer>
      )}
    </Container>
  );
}
