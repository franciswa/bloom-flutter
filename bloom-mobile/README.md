# Bloom Mobile App

A mobile dating app that matches users based on zodiac compatibility and shared interests.

## Features

- User authentication and profile management
- Zodiac-based matchmaking
- Real-time chat with matches
- Date planning and scheduling
- Push notifications for matches, messages, and date reminders
- Theme customization (light/dark/system)
- Privacy settings

## Tech Stack

- React Native with Expo
- TypeScript
- Supabase for backend and real-time features
- React Navigation for routing
- React Native Elements UI library
- Expo Notifications for push notifications

## Getting Started

### Prerequisites

- Node.js (v16 or later)
- npm or yarn
- Expo CLI
- Supabase account and project

### Environment Setup

Create a `.env` file in the root directory with the following variables:

```env
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_KEY=your_supabase_service_key
```

### Installation

1. Install dependencies:
```bash
npm install
```

2. Run database migrations:
```bash
npm run db:migrate
```

3. Start the development server:
```bash
npm start
```

## Database Migrations

The project uses SQL migrations to manage the database schema. Migrations are stored in `database/migrations/` and are executed in order.

### Creating a New Migration

```bash
npm run db:migrate:create migration_name
```

This will create a new SQL file in the migrations directory with a timestamp prefix.

### Running Migrations

```bash
npm run db:migrate
```

This will execute any pending migrations in order and record their execution in the `migrations` table.

## Notifications

The app uses Expo Notifications for push notifications and includes several types of notifications:

- Match notifications: When users are matched based on compatibility
- Message notifications: When receiving new chat messages
- Date reminders: 24 hours before scheduled dates

### Notification Settings

Users can customize their notification preferences in the Settings screen:
- Enable/disable all notifications
- Toggle specific notification types (matches, messages, date reminders)

### Message Archiving

Old messages are automatically archived after 90 days to improve performance. Archived messages are still accessible but stored in a separate table. The system automatically cleans up:

- Read notifications older than 30 days
- Unread notifications older than 90 days
- Archived messages older than 1 year
- Rejected matches older than 90 days
- Cancelled date preferences older than 30 days

## Project Structure

```
bloom-mobile/
├── src/
│   ├── components/     # Reusable UI components
│   ├── hooks/         # Custom React hooks
│   ├── screens/       # Screen components
│   ├── theme/         # Theme configuration
│   ├── types/         # TypeScript type definitions
│   └── lib/           # Utility functions and services
├── database/
│   ├── migrations/    # SQL migration files
│   └── setup.sql      # Initial database setup
└── assets/           # Images, fonts, and other static files
```

## Contributing

1. Create a feature branch
2. Make your changes
3. Run tests and ensure code quality
4. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
