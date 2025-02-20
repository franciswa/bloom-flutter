import React from 'react';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import SignInScreen from '../screens/SignInScreen';
import SignUpScreen from '../screens/SignUpScreen';
import QuestionnaireScreen from '../screens/QuestionnaireScreen';
import WelcomeScreen from '../screens/WelcomeScreen';
import ForgotPasswordScreen from '../screens/ForgotPasswordScreen';
import ResetPasswordScreen from '../screens/ResetPasswordScreen';
import { AuthStackParamList } from '../types/navigation';

const Stack = createNativeStackNavigator<AuthStackParamList>();

export default function AuthNavigator() {
  return (
    <Stack.Navigator
      screenOptions={{
        headerShown: false,
      }}
    >
      <Stack.Screen 
        name="Welcome" 
        component={WelcomeScreen}
        options={{
          headerShown: false,
          // Prevent going back to splash screen
          gestureEnabled: false,
        }}
      />
      <Stack.Screen 
        name="SignIn" 
        component={SignInScreen}
        options={{
          headerShown: true,
          headerTitle: 'Sign In',
          headerBackTitle: 'Back',
        }}
      />
      <Stack.Screen 
        name="SignUp" 
        component={SignUpScreen}
        options={{
          headerShown: true,
          headerTitle: 'Create Account',
          headerBackTitle: 'Back',
        }}
      />
      <Stack.Screen 
        name="ForgotPassword" 
        component={ForgotPasswordScreen}
        options={{
          headerShown: true,
          headerTitle: 'Reset Password',
          headerBackTitle: 'Back',
        }}
      />
      <Stack.Screen 
        name="ResetPassword" 
        component={ResetPasswordScreen}
        options={{
          headerShown: true,
          headerTitle: 'Set New Password',
          // Prevent going back to reset link
          headerBackVisible: false,
          gestureEnabled: false,
        }}
      />
    </Stack.Navigator>
  );
}
