#!/bin/bash

# Script to set up Sentry for the Bloom Flutter app

echo "🌸 Bloom Flutter App - Sentry Setup Script 🌸"
echo ""
echo "This script will help you set up Sentry for error tracking in your Flutter app."
echo "It will run the Sentry wizard to configure Sentry for your project."
echo ""

# Check if npx is installed
if ! command -v npx &> /dev/null; then
    echo "❌ Error: npx is not installed. Please install Node.js and npm first."
    exit 1
fi

# Run the Sentry wizard
echo "Running Sentry wizard..."
echo ""
npx @sentry/wizard@latest -i flutter --saas --org bloom-op --project flutter

echo ""
echo "✅ Sentry wizard completed!"
echo ""
echo "Now you need to update your environment files with the Sentry DSN."
echo "The DSN should be displayed in the output above, or you can find it in your Sentry project settings."
echo ""
echo "To update your environment files, run:"
echo "dart scripts/setup_env.dart"
echo ""
echo "Or manually update the SENTRY_DSN value in:"
echo "- .env.development"
echo "- .env.staging"
echo "- .env.production"
echo ""
echo "For more information, see the API_KEYS_GUIDE.md file."
