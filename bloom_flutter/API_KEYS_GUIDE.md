# API Keys Guide for Bloom Flutter App

This guide provides step-by-step instructions on how to obtain and set up the necessary API keys for the Bloom Flutter application.

## Table of Contents

1. [Supabase Configuration](#supabase-configuration)
2. [Sentry Configuration](#sentry-configuration)
3. [PostHog Configuration](#posthog-configuration)
4. [Setting Up Environment Files](#setting-up-environment-files)

## Supabase Configuration

Supabase is used as the backend service for authentication, database, and storage.

### Steps to Get Supabase API Keys:

1. **Create a Supabase Account**:
   - Go to [https://supabase.com/](https://supabase.com/)
   - Sign up for an account if you don't have one

2. **Create a New Project**:
   - Click on "New Project"
   - Enter a name for your project
   - Set a secure database password
   - Choose a region closest to your users
   - Click "Create new project"

3. **Get API Keys**:
   - Once your project is created, go to the project dashboard
   - In the left sidebar, click on "Settings" > "API"
   - You'll find two keys:
     - **URL**: The URL of your Supabase project (e.g., `https://abcdefghijklm.supabase.co`)
     - **anon public**: The anonymous key used for public operations
     - **service_role**: The service role key used for admin operations (keep this secure!)

4. **Copy these values** to your environment files:
   ```
   SUPABASE_URL=your-project-url
   SUPABASE_ANON_KEY=your-anon-key
   SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
   ```

## Sentry Configuration

Sentry is used for error tracking and performance monitoring.

### Steps to Get Sentry DSN:

1. **Create a Sentry Account**:
   - Go to [https://sentry.io/](https://sentry.io/)
   - Sign up for an account if you don't have one

2. **Create a New Project**:
   - Click on "Create Project"
   - Select "Flutter" as the platform
   - Enter a name for your project
   - Click "Create Project"

3. **Get DSN**:
   - After creating the project, you'll be shown the DSN (Data Source Name)
   - Alternatively, you can find it by going to:
     - Settings > Projects > [Your Project] > Client Keys (DSN)

4. **Copy the DSN** to your environment files:
   ```
   SENTRY_DSN=your-sentry-dsn
   ```

## PostHog Configuration

PostHog is used for analytics and user behavior tracking.

### Steps to Get PostHog API Key:

1. **Create a PostHog Account**:
   - Go to [https://posthog.com/](https://posthog.com/)
   - Sign up for an account if you don't have one

2. **Create a New Project** (or use the default one):
   - Click on "Create new project" if you want a separate project
   - Enter a name for your project
   - Click "Create project"

3. **Get API Key**:
   - Go to "Project Settings" > "Project API Key"
   - You'll see your API key (it starts with `phc_`)

4. **Copy the API Key** to your environment files:
   ```
   POSTHOG_API_KEY=your-posthog-api-key
   POSTHOG_HOST=https://app.posthog.com
   ```

## Setting Up Environment Files

The Bloom Flutter app uses different environment files for different build environments:

### 1. Development Environment (.env.development)

This is used during local development and testing.

```
SUPABASE_URL=https://your-dev-project-id.supabase.co
SUPABASE_ANON_KEY=your-dev-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-dev-service-role-key
SENTRY_DSN=your-dev-sentry-dsn
POSTHOG_API_KEY=your-dev-posthog-api-key
POSTHOG_HOST=https://app.posthog.com
```

### 2. Staging Environment (.env.staging)

This is used for pre-production testing.

```
SUPABASE_URL=https://your-staging-project-id.supabase.co
SUPABASE_ANON_KEY=your-staging-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-staging-service-role-key
SENTRY_DSN=your-staging-sentry-dsn
POSTHOG_API_KEY=your-staging-posthog-api-key
POSTHOG_HOST=https://app.posthog.com
```

### 3. Production Environment (.env.production)

This is used for the final production app.

```
SUPABASE_URL=https://your-prod-project-id.supabase.co
SUPABASE_ANON_KEY=your-prod-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-prod-service-role-key
SENTRY_DSN=your-prod-sentry-dsn
POSTHOG_API_KEY=your-prod-posthog-api-key
POSTHOG_HOST=https://app.posthog.com
```

## Best Practices for API Keys

1. **Never commit API keys to version control**:
   - Make sure `.env.*` files are in your `.gitignore`
   - The repository includes `.env.example` as a template

2. **Use different keys for different environments**:
   - Development
   - Staging
   - Production

3. **Regularly rotate your API keys**:
   - Especially if you suspect they might have been compromised

4. **Restrict API key permissions**:
   - Use the principle of least privilege
   - Only grant the permissions that are absolutely necessary

5. **Monitor API key usage**:
   - Regularly check the usage of your API keys
   - Look for unusual patterns that might indicate misuse

## Troubleshooting

If you encounter issues with your API keys:

1. **Verify the keys are correct**:
   - Double-check for typos or extra spaces
   - Make sure you're using the right key for the right environment

2. **Check environment loading**:
   - Ensure the app is loading the correct environment file
   - Debug by printing `AppConfig.supabaseUrl` (but remove before production)

3. **Check service status**:
   - Verify that the services (Supabase, Sentry, PostHog) are operational

4. **Contact support**:
   - Supabase: [https://supabase.com/support](https://supabase.com/support)
   - Sentry: [https://sentry.io/support/](https://sentry.io/support/)
   - PostHog: [https://posthog.com/support](https://posthog.com/support)
