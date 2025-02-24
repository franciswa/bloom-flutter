import { Button, H1, Paragraph, XStack, YStack } from 'tamagui'

export default function HomeScreen() {
  return (
    <YStack f={1} jc="center" ai="center" p="$4" space="$4">
      <H1 fontFamily="$heading" fontSize="$8" color="$primary">
        Welcome to Bloom
      </H1>
      
      <Paragraph fontFamily="$body" fontSize="$4" color="$text" ta="center">
        This is a sample screen using Tamagui components and styling system
      </Paragraph>

      <XStack space="$4">
        <Button
          size="$4"
          backgroundColor="$primary"
          onPress={() => console.log('Primary button pressed')}
        >
          Primary
        </Button>

        <Button
          size="$4"
          backgroundColor="$secondary"
          onPress={() => console.log('Secondary button pressed')}
        >
          Secondary
        </Button>
      </XStack>
    </YStack>
  )
}
