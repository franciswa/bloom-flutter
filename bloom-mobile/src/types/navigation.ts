import { NativeStackScreenProps } from '@react-navigation/native-stack';
import { CompositeScreenProps, NavigatorScreenParams } from '@react-navigation/native';
import { BottomTabScreenProps } from '@react-navigation/bottom-tabs';

export type AuthStackParamList = {
  Welcome: undefined;
  SignIn: undefined;
  SignUp: undefined;
  ForgotPassword: undefined;
  ResetPassword: {
    email: string;
    token: string;
  };
};

export type MessagesStackParamList = {
  MessagesList: undefined;
  Chat: {
    userId: string;
    name: string;
  };
};

export type MainTabParamList = {
  Matches: undefined;
  Messages: NavigatorScreenParams<MessagesStackParamList>;
  Chart: undefined;
  Notifications: undefined;
  Settings: undefined;
};

export type RootStackParamList = {
  Auth: undefined;
  Main: NavigatorScreenParams<MainTabParamList>;
};

export type AuthScreenProps<T extends keyof AuthStackParamList> = NativeStackScreenProps<
  AuthStackParamList,
  T
>;

export type MessagesScreenProps<T extends keyof MessagesStackParamList> = CompositeScreenProps<
  NativeStackScreenProps<MessagesStackParamList, T>,
  BottomTabScreenProps<MainTabParamList>
>;

export type MainScreenProps<T extends keyof MainTabParamList> = BottomTabScreenProps<
  MainTabParamList,
  T
>;

export type RootScreenProps<T extends keyof RootStackParamList> = NativeStackScreenProps<
  RootStackParamList,
  T
>;
