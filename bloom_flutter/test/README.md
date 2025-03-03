# Bloom Flutter Testing Guide

This guide provides instructions on how to run the various tests for the Bloom Flutter application.

## Test Structure

The Bloom Flutter app has three types of tests:

1. **Unit Tests**: Test individual functions, methods, and classes
2. **Widget Tests**: Test UI components in isolation
3. **Integration Tests**: Test the app as a whole

## Running Tests

### Unit Tests

Unit tests are located in the `test/unit` directory and are organized by the type of component being tested:

- `test/unit/services`: Tests for service classes
- `test/unit/providers`: Tests for provider classes (to be implemented)

To run all unit tests:

```bash
flutter test test/unit
```

To run a specific unit test file:

```bash
flutter test test/unit/services/auth_service_test.dart
```

### Widget Tests

Widget tests are located in the `test/widget` directory and test individual UI components.

To run all widget tests:

```bash
flutter test test/widget
```

To run a specific widget test:

```bash
flutter test test/widget/login_screen_test.dart
```

### Integration Tests

Integration tests are located in the `integration_test` directory and test the app as a whole.

To run integration tests on a connected device or emulator:

```bash
flutter test integration_test/app_test.dart
```

## Writing New Tests

### Unit Tests

When writing new unit tests, follow these guidelines:

1. Place the test file in the appropriate subdirectory of `test/unit`
2. Name the test file after the class being tested, with a `_test.dart` suffix
3. Use the `mocktail` package for mocking dependencies
4. Follow the Arrange-Act-Assert pattern for test structure

Example:

```dart
test('signInWithEmailAndPassword returns User when successful', () async {
  // Arrange
  when(() => mockAuth.signInWithPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenAnswer((_) async => mockAuthResponse);

  // Act
  final user = await authService.signInWithEmailAndPassword(
    email: 'test@example.com',
    password: 'password123',
  );

  // Assert
  expect(user, isNotNull);
  expect(user.id, equals('test-user-id'));
});
```

### Widget Tests

When writing new widget tests, follow these guidelines:

1. Place the test file in the `test/widget` directory
2. Name the test file after the widget being tested, with a `_test.dart` suffix
3. Use `WidgetTester` to interact with the widget
4. Mock any dependencies using the `mocktail` package

Example:

```dart
testWidgets('renders login form correctly', (WidgetTester tester) async {
  // Arrange
  when(() => mockAuthProvider.isLoading).thenReturn(false);

  // Act
  await tester.pumpWidget(
    MaterialApp(
      home: ChangeNotifierProvider<AuthProvider>.value(
        value: mockAuthProvider,
        child: const LoginScreen(),
      ),
    ),
  );

  // Assert
  expect(find.text('Sign In'), findsOneWidget);
  expect(find.byType(TextFormField), findsAtLeast(2));
});
```

### Integration Tests

When writing new integration tests, follow these guidelines:

1. Place the test file in the `integration_test` directory
2. Use `IntegrationTestWidgetsFlutterBinding.ensureInitialized()` at the start of the test
3. Test complete user flows from start to finish
4. Use `tester.pumpAndSettle()` to wait for animations to complete

Example:

```dart
testWidgets('Verify app startup and navigation', (WidgetTester tester) async {
  // Start the app
  app.main();
  
  // Wait for the app to fully load
  await tester.pumpAndSettle();
  
  // Verify UI elements and interactions
  expect(find.text('Welcome'), findsOneWidget);
  
  // Perform actions
  await tester.tap(find.byType(ElevatedButton));
  await tester.pumpAndSettle();
});
```

## Test Coverage

To generate a test coverage report:

```bash
flutter test --coverage
```

This will generate a `coverage/lcov.info` file. You can convert this to a more readable format using the `lcov` tool:

```bash
genhtml coverage/lcov.info -o coverage/html
```

Then open `coverage/html/index.html` in a web browser to view the coverage report.

## Continuous Integration

The tests are automatically run as part of the CI/CD pipeline. The pipeline will:

1. Run all unit and widget tests
2. Generate a test coverage report
3. Run integration tests on a virtual device
4. Fail the build if any tests fail or if coverage drops below the threshold

## Troubleshooting

If you encounter issues running the tests:

1. Make sure you have the latest Flutter SDK installed
2. Run `flutter pub get` to ensure all dependencies are up to date
3. Check that you have a device or emulator connected for integration tests
4. Try running `flutter clean` and then `flutter pub get` to reset the build
