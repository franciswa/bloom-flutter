import type { Session } from '@supabase/supabase-js'
import { Provider, loadThemePromise } from 'app/provider'
import { supabase } from 'app/utils/supabase/client.native'
import { useFonts } from 'expo-font'
import { SplashScreen, Stack } from 'expo-router'
import { useCallback, useEffect, useState } from 'react'
import { LogBox, View } from 'react-native'
import { GestureHandlerRootView } from 'react-native-gesture-handler'
import { TamaguiProvider } from 'tamagui'
import config from '../tamagui.config'

SplashScreen.preventAutoHideAsync()

LogBox.ignoreLogs([
  'Cannot update a component',
  'You are setting the style',
  'No route',
  'duplicate ID',
  'Require cycle',
])

export default function HomeLayout() {
  const [fontLoaded] = useFonts({
    'Geist': require('../assets/fonts/Geist-VariableFont_wght.ttf'),
    'OpenSauceOne-Light': require('../assets/fonts/OpenSauceOne-Light.ttf'),
    'OpenSauceOne': require('../assets/fonts/OpenSauceOne-Regular.ttf'),
    'OpenSauceOne-Medium': require('../assets/fonts/OpenSauceOne-Medium.ttf'),
    'OpenSauceOne-SemiBold': require('../assets/fonts/OpenSauceOne-SemiBold.ttf'),
    'OpenSauceOne-Bold': require('../assets/fonts/OpenSauceOne-Bold.ttf'),
  })

  const [themeLoaded, setThemeLoaded] = useState(false)
  const [sessionLoadAttempted, setSessionLoadAttempted] = useState(false)
  const [initialSession, setInitialSession] = useState<Session | null>(null)

  useEffect(() => {
    supabase.auth
      .getSession()
      .then(({ data }) => {
        if (data) {
          setInitialSession(data.session)
        }
      })
      .finally(() => {
        setSessionLoadAttempted(true)
      })
  }, [])

  useEffect(() => {
    loadThemePromise.then(() => {
      setThemeLoaded(true)
    })
  }, [])

  const onLayoutRootView = useCallback(async () => {
    if (fontLoaded && sessionLoadAttempted) {
      await SplashScreen.hideAsync()
    }
  }, [fontLoaded, sessionLoadAttempted])

  if (!themeLoaded || !fontLoaded || !sessionLoadAttempted) {
    return null
  }

  return (
    <TamaguiProvider config={config}>
      <GestureHandlerRootView style={{ flex: 1 }}>
        <View style={{ flex: 1 }} onLayout={onLayoutRootView}>
          <Provider initialSession={initialSession}>
            <Stack screenOptions={{ headerShown: false }}>
              <Stack.Screen
                name="(drawer)/(tabs)/index"
                options={{
                  headerShown: false,
                }}
              />
              <Stack.Screen
                name="create"
                options={{
                  headerShown: false,
                }}
              />
              <Stack.Screen
                name="settings/index"
                options={{
                  headerShown: true,
                  headerBackTitle: 'Back',
                }}
              />
            </Stack>
          </Provider>
        </View>
      </GestureHandlerRootView>
    </TamaguiProvider>
  )
}
