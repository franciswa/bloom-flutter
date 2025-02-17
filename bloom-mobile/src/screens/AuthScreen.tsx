import React, { useState } from 'react';
import { Alert, Platform, KeyboardAvoidingView } from 'react-native';
import { 
  YStack, 
  XStack,
  View,
  Text, 
  Input, 
  Button, 
  H1,
  Paragraph,
  Separator,
  SizableText,
  Spinner,
  Theme,
  AnimatePresence,
  Anchor,
} from 'tamagui';
import { Ionicons } from '@expo/vector-icons';
import { NativeStackNavigationProp } from '@react-navigation/native-stack';
import { RootStackParamList } from '../types/navigation';
import { supabase } from '../lib/supabase';

type AuthScreenProps = {
  navigation: NativeStackNavigationProp<RootStackParamList, 'Auth'>;
};

export default function AuthScreen({ navigation }: AuthScreenProps) {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [isLogin, setIsLogin] = useState(true);

  async function handleAuth() {
    setLoading(true);
    try {
      if (isLogin) {
        const { error: signInError } = await supabase.auth.signInWithPassword({
          email,
          password,
        });
        if (signInError) throw signInError;

        // Check if user has completed questionnaire
        const { data: { user } } = await supabase.auth.getUser();
        if (!user) throw new Error('No user found');

        const { data: profile, error: profileError } = await supabase
          .from('profiles')
          .select('questionnaire_completed')
          .eq('id', user.id)
          .single();

        if (profileError) throw profileError;

        // Navigate based on questionnaire completion
        if (profile.questionnaire_completed) {
          navigation.replace('MainTabs', { screen: 'Matches' });
        } else {
          navigation.replace('Questionnaire');
        }
      } else {
        const { error: signUpError } = await supabase.auth.signUp({
          email,
          password,
        });
        if (signUpError) throw signUpError;
        Alert.alert(
          'Success', 
          'Check your email for the confirmation link! Once confirmed, you can sign in.',
          [{ text: 'OK', onPress: () => setIsLogin(true) }]
        );
      }
    } catch (error) {
      Alert.alert('Error', (error as Error).message);
    } finally {
      setLoading(false);
    }
  }

  return (
    <KeyboardAvoidingView
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
      style={{ flex: 1 }}
    >
      <View
        backgroundColor="$background"
        flex={1}
        justifyContent="center"
        alignItems="center"
        padding="$5"
      >
        <View
          flexDirection="column"
          alignItems="stretch"
          minWidth="100%"
          maxWidth="100%"
          gap="$5"
          backgroundColor="$backgroundStrong"
          borderRadius="$4"
          padding="$6"
          $gtSm={{
            paddingVertical: '$7',
            paddingHorizontal: '$7',
            width: 400,
            maxWidth: '85%'
          }}
        >
          <H1
            alignSelf="center"
            size="$8"
            color="$primary"
            $xs={{
              size: '$7',
            }}
          >
            {isLogin ? 'Sign in to your account' : 'Create an account'}
          </H1>

          <View flexDirection="column" gap="$4">
            <View flexDirection="column" gap="$2">
              <Text color="$text" fontSize="$3" marginBottom="$1">Email</Text>
              <Input
                size="$4"
                placeholder="email@example.com"
                padding="$3"
                value={email}
                onChangeText={setEmail}
                autoCapitalize="none"
                keyboardType="email-address"
              />
            </View>

            <View flexDirection="column" gap="$2">
              <Text color="$text" fontSize="$3" marginBottom="$1">Password</Text>
              <Input
                size="$4"
                placeholder="Enter password"
                padding="$3"
                value={password}
                onChangeText={setPassword}
                secureTextEntry
                autoCapitalize="none"
              />
              {isLogin && (
                <Anchor alignSelf="flex-end" onPress={() => Alert.alert('Coming soon')}>
                  <Paragraph
                    color="$gray11"
                    hoverStyle={{
                      color: '$gray12',
                    }}
                    size="$2"
                    marginTop="$2"
                  >
                    Forgot your password?
                  </Paragraph>
                </Anchor>
              )}
            </View>
          </View>

          <Theme inverse>
            <Button
              disabled={loading}
              onPress={handleAuth}
              width="100%"
              size="$4"
              marginVertical="$3"
              iconAfter={
                <AnimatePresence>
                  {loading && (
                    <Spinner
                      color="$color"
                      key="loading-spinner"
                      opacity={1}
                      scale={1}
                      animation="quick"
                      position="absolute"
                      left="60%"
                      enterStyle={{
                        opacity: 0,
                        scale: 0.5,
                      }}
                      exitStyle={{
                        opacity: 0,
                        scale: 0.5,
                      }}
                    />
                  )}
                </AnimatePresence>
              }
            >
              <Button.Text>{isLogin ? 'Sign In' : 'Sign Up'}</Button.Text>
            </Button>
          </Theme>

          <View flexDirection="column" gap="$4" width="100%" alignItems="center">
            <Theme>
              <View
                flexDirection="column"
                gap="$4"
                width="100%"
                alignSelf="center"
                alignItems="center"
              >
                <View flexDirection="row" width="100%" alignItems="center" gap="$4" marginVertical="$4">
                  <Separator />
                  <Paragraph size="$3">Or</Paragraph>
                  <Separator />
                </View>
                <View flexDirection="column" width="100%" gap="$4">
                  <Button
                    size="$4"
                    width="100%"
                    onPress={() => Alert.alert('Coming soon')}
                    icon={<Ionicons name="logo-github" size={20} color="$gray10" />}
                  >
                    Continue with Github
                  </Button>
                  <Button
                    size="$4"
                    width="100%"
                    onPress={() => Alert.alert('Coming soon')}
                    icon={<Ionicons name="logo-facebook" size={20} color="$blue10" />}
                  >
                    Continue with Facebook
                  </Button>
                </View>
              </View>
            </Theme>
          </View>

          <Paragraph textDecorationStyle="unset" textAlign="center">
            {isLogin ? "Don't have an account? " : "Already have an account? "}
            <SizableText
              onPress={() => setIsLogin(!isLogin)}
              hoverStyle={{
                color: '$colorHover',
              }}
              textDecorationLine="underline"
              color="$primary"
            >
              {isLogin ? 'Sign up' : 'Sign in'}
            </SizableText>
          </Paragraph>
        </View>
      </View>
    </KeyboardAvoidingView>
  );
}
