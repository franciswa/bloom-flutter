# Bloom - Astrology Dating App

Bloom is a modern dating application that uses astrology to help users find compatible matches. This Flutter application is the mobile client for the Bloom platform.

## Features

- User authentication and profile management
- Astrological chart generation and analysis
- Compatibility matching based on astrological factors
- Real-time messaging between matched users
- Date planning and scheduling
- Analytics and error tracking

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Supabase account for backend services
- PostHog account for analytics (optional)
- Sentry account for error tracking (optional)

### Installation

1. Clone the repository
2. Install dependencies: `flutter pub get`
3. Set up environment variables using one of these methods:
   
   **Method 1: Manual Setup**
   - Copy `.env.example` to `.env.development`, `.env.staging`, and `.env.production`
   - Fill in the required values for each environment (see [API Keys Guide](API_KEYS_GUIDE.md))
   
   **Method 2: Using the Setup Scripts**
   - For API keys: `dart scripts/setup_env.dart`
   - For Sentry: `./scripts/setup_sentry.sh`
   - Follow the prompts to enter your API keys
   - The scripts will create and update the necessary files

4. Run the app: `flutter run --flavor development`

### API Keys

The app requires several API keys to function properly:

1. **Supabase**: For backend services (authentication, database, storage)
   - URL: `https://yqgssgqzlflqwuahtxbk.supabase.co`
   - Anonymous Key: Already configured in environment files
   - Service Role Key: Already configured in environment files

2. **Sentry**: For error tracking and performance monitoring
   - Project URL: `https://bloom-op.sentry.io/issues/?project=4508888584880128`
   - DSN: Already configured in environment files
   - Setup complete: See [Sentry Setup Note](SENTRY_SETUP_NOTE.md) for details

3. **PostHog**: For analytics and user behavior tracking
   - API Key: Already configured in environment files
   - Host: `https://us.posthog.com`

For detailed instructions on obtaining and managing API keys, see the [API Keys Guide](API_KEYS_GUIDE.md).

### Environment Variables

The app uses environment variables for configuration. Create the following files:

- `.env.development` - Development environment configuration
- `.env.staging` - Staging environment configuration
- `.env.production` - Production environment configuration

Each file should contain:

```
SUPABASE_URL=your-supabase-url
SUPABASE_ANON_KEY=your-supabase-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-supabase-service-role-key
SENTRY_DSN=your-sentry-dsn
POSTHOG_API_KEY=your-posthog-api-key
POSTHOG_HOST=https://app.posthog.com
```

## Project Structure

The project follows a standard Flutter architecture with providers for state management and Supabase for backend services.

### Key Directories

- `lib/models` - Data models
- `lib/services` - Service classes for API communication
- `lib/providers` - State management providers
- `lib/screens` - UI screens
- `lib/widgets` - Reusable UI components
- `lib/utils` - Utility functions and helpers
- `lib/theme` - App theme configuration
- `lib/config` - App configuration

## Analytics

The app uses PostHog for analytics tracking. Key events tracked include:

- App lifecycle events (start, background, foreground)
- Authentication events (login, registration, logout)
- Screen views
- Feature usage
- Error events

## Error Tracking

The app uses Sentry for error tracking and crash reporting. All errors are automatically captured and sent to Sentry for analysis.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
