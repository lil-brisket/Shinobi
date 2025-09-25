-- Banking System Migration
-- Creates all tables and indices for the comprehensive banking system

-- players table
create table if not exists players (
  id uuid primary key default gen_random_uuid(),
  username text unique not null,
  created_at timestamptz not null default now()
);

-- wallets table
create table if not exists wallets (
  player_id uuid primary key references players(id) on delete cascade,
  pocket_balance bigint not null default 0,
  bank_balance bigint not null default 0,
  updated_at timestamptz not null default now()
);

-- transactions ledger
-- kind examples: 'DEPOSIT','WITHDRAW','TRANSFER_SEND','TRANSFER_RECEIVE','INTEREST_CLAIM','ADMIN_ADJUST'
create table if not exists transactions (
  id bigserial primary key,
  created_at timestamptz not null default now(),
  actor_id uuid references players(id),
  sender_id uuid references players(id),
  receiver_id uuid references players(id),
  source text not null check (source in ('POCKET','BANK')),
  destination text not null check (destination in ('POCKET','BANK')),
  amount bigint not null check (amount > 0),
  kind text not null,
  memo text,
  idempotency_key text unique
);

-- daily interest offers
create table if not exists interest_offers (
  id bigserial primary key,
  player_id uuid not null references players(id) on delete cascade,
  for_date date not null,
  bank_balance_snapshot bigint not null,
  rate_bps int not null,
  amount bigint not null,
  claim_deadline timestamptz not null,
  claimed_at timestamptz,
  created_at timestamptz not null default now(),
  unique (player_id, for_date)
);

-- indices for performance
create index if not exists idx_transactions_sender on transactions (sender_id);
create index if not exists idx_transactions_receiver on transactions (receiver_id);
create index if not exists idx_transactions_created_at on transactions (created_at);
create index if not exists idx_players_username on players (lower(username));
create index if not exists idx_interest_offers_player_date on interest_offers (player_id, for_date);
create index if not exists idx_interest_offers_deadline on interest_offers (claim_deadline);

-- constraints to prevent negative balances (only add if they don't exist)
do $$
begin
  if not exists (
    select 1 from pg_constraint 
    where conname = 'check_pocket_balance_non_negative'
  ) then
    alter table wallets add constraint check_pocket_balance_non_negative 
      check (pocket_balance >= 0);
  end if;
  
  if not exists (
    select 1 from pg_constraint 
    where conname = 'check_bank_balance_non_negative'
  ) then
    alter table wallets add constraint check_bank_balance_non_negative 
      check (bank_balance >= 0);
  end if;
end $$;

-- function to update wallet updated_at timestamp
create or replace function update_wallet_timestamp()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

-- trigger to automatically update wallet timestamp
drop trigger if exists update_wallets_updated_at on wallets;
create trigger update_wallets_updated_at
  before update on wallets
  for each row
  execute function update_wallet_timestamp();

-- Enable Row Level Security
ALTER TABLE players ENABLE ROW LEVEL SECURITY;
ALTER TABLE wallets ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE interest_offers ENABLE ROW LEVEL SECURITY;
