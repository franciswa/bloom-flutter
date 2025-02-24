import React from 'react';
import { FlatList, RefreshControl } from 'react-native';
import { YStack, Text, Card, XStack, Spinner, Button } from 'tamagui';
import { useDatePreferences } from '../hooks/useDatePreferences';
import { DateNightScreenProps } from '../types/navigation';
import { ZODIAC_SIGNS } from '../types/chart';
import { formatDistanceToNow } from 'date-fns';
import { DatePreference } from '../services/datePreferences';

type Props = DateNightScreenProps<'DatePreferences'>;

export function DatePreferencesScreen({ navigation }: Props) {
  const {
    preferences,
    loading,
    error,
    loadPreferences,
    cancelPreference,
    deletePreference,
  } = useDatePreferences();

  React.useEffect(() => {
    loadPreferences();
  }, [loadPreferences]);

  const renderPreference = ({ item }: { item: DatePreference }) => (
    <Card
      bordered
      elevate
      marginHorizontal="$4"
      marginVertical="$2"
      padding="$4"
      backgroundColor="$background"
    >
      <YStack space="$2">
        <XStack justifyContent="space-between" alignItems="center">
          <Text
            fontFamily="$astrological"
            fontSize="$6"
            color="$text"
          >
            {ZODIAC_SIGNS[item.desired_zodiac].symbol}
          </Text>
          <Text
            color="$textSecondary"
            fontSize="$3"
          >
            {formatDistanceToNow(new Date(item.created_at), { addSuffix: true })}
          </Text>
        </XStack>

        <Text fontSize="$4" color="$text">
          {item.date_type} date with a {ZODIAC_SIGNS[item.desired_zodiac].label}
        </Text>

        <Text fontSize="$3" color="$textSecondary">
          Preferred date: {new Date(item.preferred_date).toLocaleDateString()}
        </Text>

        <Text
          fontSize="$3"
          color={item.status === 'pending' ? '$info' : item.status === 'matched' ? '$success' : '$textSecondary'}
        >
          Status: {item.status.charAt(0).toUpperCase() + item.status.slice(1)}
        </Text>

        {item.status === 'pending' && (
          <XStack space="$2" justifyContent="flex-end" marginTop="$2">
            <Button
              size="$3"
              variant="outlined"
              backgroundColor="$warning"
              onPress={() => cancelPreference(item.id)}
            >
              Cancel
            </Button>
            <Button
              size="$3"
              variant="outlined"
              backgroundColor="$danger"
              onPress={() => deletePreference(item.id)}
            >
              Delete
            </Button>
          </XStack>
        )}
      </YStack>
    </Card>
  );

  if (error) {
    return (
      <YStack flex={1} padding="$4" justifyContent="center" alignItems="center">
        <Text color="$danger" fontSize="$5" textAlign="center" marginBottom="$4">
          {error}
        </Text>
        <Button
          variant="outlined"
          backgroundColor="$info"
          onPress={loadPreferences}
          size="$4"
        >
          Retry
        </Button>
      </YStack>
    );
  }

  return (
    <YStack flex={1} backgroundColor="$background">
      <FlatList
        data={preferences}
        renderItem={renderPreference}
        keyExtractor={(item) => item.id}
        contentContainerStyle={[
          { paddingVertical: 16 },
          preferences.length === 0 && { flex: 1 }
        ]}
        refreshControl={
          <RefreshControl
            refreshing={loading}
            onRefresh={loadPreferences}
            tintColor="#666666"
          />
        }
        ListEmptyComponent={
          <YStack flex={1} padding="$4" justifyContent="center" alignItems="center">
            <Text color="$textSecondary" fontSize="$4" textAlign="center">
              No date preferences yet
            </Text>
            <Button
              variant="outlined"
              backgroundColor="$info"
              onPress={() => navigation.navigate('DateNightZodiac')}
              size="$4"
              marginTop="$4"
            >
              Create New Date Preference
            </Button>
          </YStack>
        }
      />
    </YStack>
  );
}
