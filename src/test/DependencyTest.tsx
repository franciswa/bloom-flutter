import React, { useEffect, useState } from 'react'
import { View, Text as RNText } from 'react-native'
import { createClient } from '@supabase/supabase-js'
import { YStack, XStack, Text, Button } from 'tamagui'

// TypeScript interface to verify TS support
interface TestData {
  id: number
  message: string
  created_at: string
}

// Supabase client to test connection
const supabase = createClient(
  process.env.EXPO_PUBLIC_SUPABASE_URL || '',
  process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY || ''
)

export const DependencyTest = () => {
  const [data, setData] = useState<TestData | null>(null)
  const [error, setError] = useState<string | null>(null)

  // Test Supabase connection
  const testSupabase = async () => {
    try {
      const { data, error } = await supabase
        .from('test')
        .select('*')
        .limit(1)
      
      if (error) throw error
      setData(data[0])
      setError(null)
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Unknown error')
    }
  }

  return (
    <YStack space="$4" padding="$4">
      <Text fontSize="$6" fontWeight="bold">Dependency Test</Text>
      
      {/* Test React Native components */}
      <View style={{ padding: 10, backgroundColor: '#f0f0f0' }}>
        <RNText>React Native Components ✅</RNText>
      </View>

      {/* Test Tamagui components */}
      <XStack space="$2" alignItems="center">
        <Button
          size="$4"
          theme="blue"
          onPress={testSupabase}
        >
          Test Supabase
        </Button>
        <Text>Tamagui Components ✅</Text>
      </XStack>

      {/* Display Supabase test results */}
      {data && (
        <YStack space="$2">
          <Text color="$green10">Supabase Connection ✅</Text>
          <Text>Data: {JSON.stringify(data)}</Text>
        </YStack>
      )}
      
      {error && (
        <Text color="$red10">Error: {error}</Text>
      )}

      {/* TypeScript verification */}
      <Text color="$blue10">TypeScript Support ✅</Text>
    </YStack>
  )
}
