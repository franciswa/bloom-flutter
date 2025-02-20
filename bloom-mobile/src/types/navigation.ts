import { NavigatorScreenParams } from '@react-navigation/native';

export type TabParamList = {
  Matches: undefined;
  Messages: undefined;
  Dates: undefined;
  Profile: undefined;
  Settings: undefined;
  Notifications: undefined;
};

export type RootStackParamList = {
  Auth: undefined;
  SignIn: undefined;
  SignUp: undefined;
  MainTabs: NavigatorScreenParams<TabParamList>;
  Chat: {
    matchId: string;
    matchName: string;
    matchPhoto: string;
  };
  Match: {
    matchId: string;
  };
  Questionnaire: {
    type: 'personality' | 'lifestyle' | 'values';
  };
  Date: {
    matchId: string;
    dateId?: string;
  };
};

export type AuthStackParamList = {
  Welcome: undefined;
  SignIn: undefined;
  SignUp: undefined;
  ForgotPassword: undefined;
  ResetPassword: {
    token: string;
  };
};

// Helper type for useNavigation hook
declare global {
  namespace ReactNavigation {
    interface RootParamList extends RootStackParamList {}
  }
}
