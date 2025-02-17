import { NavigatorScreenParams } from '@react-navigation/native';

export type TabParamList = {
  Matches: undefined;
  Chat: undefined;
  Date: undefined;
  Profile: undefined;
  Settings: undefined;
  Notifications: undefined;
};

export type RootStackParamList = {
  Auth: undefined;
  Questionnaire: undefined;
  MainTabs: NavigatorScreenParams<TabParamList>;
  Chat: {
    matchId: string;
  };
  Date: undefined;
  Notifications: undefined;
};
