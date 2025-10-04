# Supabase Setup Guide for Kage MMORPG

This guide will help you set up Supabase for your Kage MMORPG Flutter project.

## Prerequisites

1. A Supabase account (sign up at [supabase.com](https://supabase.com))
2. Flutter development environment
3. Your project dependencies installed (`flutter pub get`)

## Step 1: Create Supabase Project

1. Go to [supabase.com](https://supabase.com) and sign in
2. Click "New Project"
3. Choose your organization
4. Enter project details:
   - **Name**: `kage-mmorpg` (or your preferred name)
   - **Database Password**: Generate a strong password
   - **Region**: Choose closest to your users
5. Click "Create new project"
6. Wait for the project to be created (usually 2-3 minutes)

## Step 2: Get Project Credentials

1. In your Supabase dashboard, go to **Settings** → **API**
2. Copy the following values:
   - **Project URL** (starts with `https://`)
   - **anon public** key (starts with `eyJ`)

## Step 3: Update Configuration

1. Open `lib/config/supabase_config.dart`
2. Replace the placeholder values:

```dart
class SupabaseConfig {
  static const String supabaseUrl = 'YOUR_ACTUAL_PROJECT_URL';
  static const String supabaseAnonKey = 'YOUR_ACTUAL_ANON_KEY';
  // ... rest of the file stays the same
}
```

## Step 4: Set Up Database Schema

1. In your Supabase dashboard, go to **SQL Editor**
2. Copy the contents of `supabase/schema.sql`
3. Paste it into the SQL editor
4. Click "Run" to execute the schema
5. Verify all tables were created successfully

## Step 5: Set Up Security Policies

1. In the SQL Editor, copy the contents of `supabase/rls_policies.sql`
2. Paste and run the policies
3. Verify RLS is enabled on all tables

## Step 6: Configure Authentication

1. In Supabase dashboard, go to **Authentication** → **Settings**
2. Configure the following:

### Site URL
- Set to your app's URL (for development: `http://localhost:3000`)

### Redirect URLs
Add these URLs (adjust for your environment):
```
http://localhost:3000/**
https://your-domain.com/**
```

### Email Settings (Optional)
- Configure SMTP settings if you want custom email templates
- Or use Supabase's default email service

## Step 7: Test the Setup

1. Run your Flutter app: `flutter run`
2. Try to register a new account
3. Check the Supabase dashboard:
   - **Authentication** → **Users** should show your new user
   - **Table Editor** → **players** should show the new player record

## Step 8: Environment Variables (Recommended)

For better security, consider using environment variables:

1. Create a `.env` file in your project root:
```
SUPABASE_URL=your_project_url
SUPABASE_ANON_KEY=your_anon_key
```

2. Add `.env` to your `.gitignore` file

3. Use a package like `flutter_dotenv` to load these values:
```yaml
dependencies:
  flutter_dotenv: ^5.1.0
```

## Database Schema Overview

The database includes these main tables:

### Core Tables
- **players**: Player profiles and stats
- **villages**: Available villages with elements
- **items**: Master list of all items
- **jutsus**: Master list of all jutsus

### Player Data
- **player_items**: Player inventory
- **player_jutsus**: Learned jutsus with mastery
- **equipment**: Equipped items
- **battle_history**: Battle records
- **banking**: Bank accounts and interest

### Social Features
- **clans**: Clan information
- **clan_members**: Clan membership
- **chat_messages**: Chat system
- **player_missions**: Mission assignments

### Utility
- **timers**: Various game timers
- **news**: Game news and announcements
- **missions**: Available missions

## Security Features

- **Row Level Security (RLS)**: Players can only access their own data
- **Authentication**: Secure user management
- **Data validation**: Database constraints ensure data integrity
- **API keys**: Separate keys for different access levels

## Next Steps

1. **Test Authentication**: Verify login/register works
2. **Test Data Operations**: Try creating/updating player data
3. **Monitor Usage**: Check Supabase dashboard for API usage
4. **Set Up Backups**: Configure automatic backups in Supabase
5. **Performance**: Monitor query performance and add indexes as needed

## Troubleshooting

### Common Issues

1. **"Invalid API key"**: Check your anon key is correct
2. **"Failed to create user"**: Check email confirmation settings
3. **"Row Level Security"**: Ensure RLS policies are properly set up
4. **"Connection timeout"**: Check your internet connection and Supabase status

### Useful Commands

```bash
# Check Supabase status
curl https://api.supabase.com/v1/projects

# Test connection
flutter run --verbose
```

### Getting Help

- [Supabase Documentation](https://supabase.com/docs)
- [Flutter Supabase Documentation](https://supabase.com/docs/guides/getting-started/flutter)
- [Supabase Discord Community](https://discord.supabase.com)

## Production Considerations

1. **Backup Strategy**: Set up automated backups
2. **Monitoring**: Use Supabase monitoring tools
3. **Scaling**: Plan for database scaling as user base grows
4. **Security**: Regularly review RLS policies
5. **Performance**: Monitor and optimize slow queries

---

**Note**: Keep your database credentials secure and never commit them to version control!
