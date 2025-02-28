import 'dart:io';

/// A simple script to help set up environment files with API keys
void main() async {
  print('🌸 Bloom Flutter App - Environment Setup Script 🌸\n');
  print('This script will help you set up your environment files with API keys.');
  print('For detailed instructions on obtaining API keys, please refer to API_KEYS_GUIDE.md\n');

  // Define environment types
  final environments = ['development', 'staging', 'production'];

  // Ask which environment to set up
  print('Which environment would you like to set up?');
  for (var i = 0; i < environments.length; i++) {
    print('${i + 1}. ${environments[i]}');
  }
  print('4. All environments');
  
  stdout.write('\nEnter your choice (1-4): ');
  final choice = int.tryParse(stdin.readLineSync() ?? '') ?? 0;
  
  if (choice < 1 || choice > 4) {
    print('Invalid choice. Exiting...');
    return;
  }
  
  final selectedEnvironments = choice == 4 
      ? environments 
      : [environments[choice - 1]];
  
  // Process each selected environment
  for (final env in selectedEnvironments) {
    await setupEnvironment(env);
  }
  
  print('\n✅ Environment setup complete!');
  print('You can now run the app with:');
  print('flutter run --flavor ${selectedEnvironments.first} --target lib/main.dart');
}

/// Set up a specific environment
Future<void> setupEnvironment(String env) async {
  print('\n📝 Setting up $env environment...');
  
  final envFile = '.env.$env';
  final envExample = '.env.example';
  
  // Check if example file exists
  if (!await File(envExample).exists()) {
    print('❌ Error: $envExample file not found. Please make sure it exists.');
    return;
  }
  
  // Read example file
  final exampleLines = await File(envExample).readAsLines();
  final Map<String, String> envVars = {};
  
  // Extract variable names from example file
  for (final line in exampleLines) {
    if (line.trim().isEmpty || line.trim().startsWith('#')) continue;
    
    final parts = line.split('=');
    if (parts.length >= 2) {
      final key = parts[0].trim();
      final value = parts.sublist(1).join('=').trim();
      envVars[key] = value;
    }
  }
  
  // Check if env file already exists
  final envFileExists = await File(envFile).exists();
  if (envFileExists) {
    stdout.write('⚠️ $envFile already exists. Overwrite? (y/n): ');
    final overwrite = stdin.readLineSync()?.toLowerCase() ?? 'n';
    if (overwrite != 'y') {
      print('Skipping $env environment setup...');
      return;
    }
    
    // Read existing values
    final existingLines = await File(envFile).readAsLines();
    for (final line in existingLines) {
      if (line.trim().isEmpty || line.trim().startsWith('#')) continue;
      
      final parts = line.split('=');
      if (parts.length >= 2) {
        final key = parts[0].trim();
        final value = parts.sublist(1).join('=').trim();
        envVars[key] = value;
      }
    }
  }
  
  // Prompt for each variable
  print('\nPlease enter the values for the $env environment:');
  print('(Press Enter to keep existing values or use default values)\n');
  
  // Supabase Configuration
  print('--- Supabase Configuration ---');
  envVars['SUPABASE_URL'] = promptForValue('SUPABASE_URL', envVars['SUPABASE_URL']);
  envVars['SUPABASE_ANON_KEY'] = promptForValue('SUPABASE_ANON_KEY', envVars['SUPABASE_ANON_KEY']);
  envVars['SUPABASE_SERVICE_ROLE_KEY'] = promptForValue('SUPABASE_SERVICE_ROLE_KEY', envVars['SUPABASE_SERVICE_ROLE_KEY']);
  
  // Sentry Configuration
  print('\n--- Sentry Configuration ---');
  envVars['SENTRY_DSN'] = promptForValue('SENTRY_DSN', envVars['SENTRY_DSN']);
  
  // PostHog Configuration
  print('\n--- PostHog Configuration ---');
  envVars['POSTHOG_API_KEY'] = promptForValue('POSTHOG_API_KEY', envVars['POSTHOG_API_KEY']);
  envVars['POSTHOG_HOST'] = promptForValue('POSTHOG_HOST', envVars['POSTHOG_HOST']);
  
  // Write to file
  final buffer = StringBuffer();
  
  // Add Supabase section
  buffer.writeln('# Supabase Configuration');
  buffer.writeln('SUPABASE_URL=${envVars['SUPABASE_URL']}');
  buffer.writeln('SUPABASE_ANON_KEY=${envVars['SUPABASE_ANON_KEY']}');
  buffer.writeln('SUPABASE_SERVICE_ROLE_KEY=${envVars['SUPABASE_SERVICE_ROLE_KEY']}');
  buffer.writeln();
  
  // Add Sentry section
  buffer.writeln('# Sentry Configuration');
  buffer.writeln('SENTRY_DSN=${envVars['SENTRY_DSN']}');
  buffer.writeln();
  
  // Add PostHog section
  buffer.writeln('# PostHog Configuration');
  buffer.writeln('POSTHOG_API_KEY=${envVars['POSTHOG_API_KEY']}');
  buffer.writeln('POSTHOG_HOST=${envVars['POSTHOG_HOST']}');
  
  // Save the file
  await File(envFile).writeAsString(buffer.toString());
  print('\n✅ Successfully wrote $envFile');
}

/// Prompt for a value with a default
String promptForValue(String key, String? defaultValue) {
  final defaultDisplay = defaultValue != null && defaultValue.isNotEmpty 
      ? ' (current: $defaultValue)' 
      : '';
  
  stdout.write('$key$defaultDisplay: ');
  final input = stdin.readLineSync() ?? '';
  
  return input.isEmpty ? (defaultValue ?? '') : input;
}
