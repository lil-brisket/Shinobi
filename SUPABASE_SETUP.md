# Supabase Setup Instructions

## Getting Your Supabase Credentials

1. Go to [supabase.com](https://supabase.com) and sign in to your account
2. Navigate to your project dashboard
3. Go to **Settings** → **API**
4. Copy the following values:
   - **Project URL** (looks like: `https://your-project-id.supabase.co`)
   - **anon/public key** (starts with `eyJ...`)

## Configuring Your App

1. Open `lib/config/supabase_config.dart`
2. Replace the placeholder values:
   ```dart
   static const String url = 'https://your-project-id.supabase.co';
   static const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
   ```

## Security Notes

- Never commit your actual Supabase credentials to version control
- The `anonKey` is safe to use in client-side applications
- For production, consider using environment variables or a secure configuration system

## Database Setup

Make sure your Supabase database has the required tables and functions:
- `clans` table
- `clan_members` table  
- `clan_applications` table
- `clan_board_posts` table
- Required RPC functions (see `supabase/functions/` directory)

## Testing the Connection

After updating the configuration:
1. Run `flutter clean`
2. Run `flutter pub get`
3. Run your app - the Supabase initialization error should be resolved
