-- Revoke all permissions from anon and authenticated roles
-- This ensures that RLS policies are the only way to control data access

-- Revoke all permissions on all tables in public schema
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM anon;
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM authenticated;

-- Revoke all permissions on all sequences in public schema
REVOKE ALL ON ALL SEQUENCES IN SCHEMA public FROM anon;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA public FROM authenticated;

-- Revoke all permissions on all functions in public schema
REVOKE ALL ON ALL FUNCTIONS IN SCHEMA public FROM anon;
REVOKE ALL ON ALL FUNCTIONS IN SCHEMA public FROM authenticated;

-- Note: PostgreSQL doesn't support REVOKE ALL ON ALL TYPES
-- Type permissions are typically not a security concern for custom types

-- Note: This migration ensures that RLS policies are the primary security mechanism
-- All data access will now be controlled through Row Level Security policies
