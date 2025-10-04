class SupabaseConfig {
  // Development configuration
  static const bool isDevelopment = true;
  
  // Supabase configuration - always use the actual Supabase URL
  static const String supabaseUrl = 'https://zkflxfrjepjkqicauhsd.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InprZmx4ZnJqZXBqa3FpY2F1aHNkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk1ODU4NjksImV4cCI6MjA3NTE2MTg2OX0.t1rmqyO7V6rnZyTYdrKG9EV5Kv3Xove9W4abCrOl364';
  
  // Always use the Supabase URL for API calls
  static String get baseUrl => supabaseUrl;
  
  // Database table names
  static const String playersTable = 'players';
  static const String villagesTable = 'villages';
  static const String itemsTable = 'items';
  static const String jutsusTable = 'jutsus';
  static const String playerItemsTable = 'player_items';
  static const String playerJutsusTable = 'player_jutsus';
  static const String equipmentTable = 'equipment';
  static const String battleHistoryTable = 'battle_history';
  static const String missionsTable = 'missions';
  static const String playerMissionsTable = 'player_missions';
  static const String clansTable = 'clans';
  static const String clanMembersTable = 'clan_members';
  static const String bankingTable = 'banking';
  static const String chatMessagesTable = 'chat_messages';
  static const String newsTable = 'news';
  static const String timersTable = 'timers';
}
