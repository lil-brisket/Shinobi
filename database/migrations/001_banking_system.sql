-- Banking System Migration
-- Creates all tables and indices for the comprehensive banking system

-- players table
create table players (
  id uuid primary key default gen_random_uuid(),
  username text unique not null,
  created_at timestamptz not null default now()
);

-- wallets table
create table wallets (
  player_id uuid primary key references players(id) on delete cascade,
  pocket_balance bigint not null default 0,
  bank_balance bigint not null default 0,
  updated_at timestamptz not null default now()
);

-- transactions ledger
-- kind examples: 'DEPOSIT','WITHDRAW','TRANSFER_SEND','TRANSFER_RECEIVE','INTEREST_CLAIM','ADMIN_ADJUST'
create table transactions (
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
create table interest_offers (
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
create index on transactions (sender_id);
create index on transactions (receiver_id);
create index on transactions (created_at);
create index on players (lower(username));
create index on interest_offers (player_id, for_date);
create index on interest_offers (claim_deadline);

-- constraints to prevent negative balances
alter table wallets add constraint check_pocket_balance_non_negative 
  check (pocket_balance >= 0);
alter table wallets add constraint check_bank_balance_non_negative 
  check (bank_balance >= 0);

-- function to update wallet updated_at timestamp
create or replace function update_wallet_timestamp()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

-- trigger to automatically update wallet timestamp
create trigger update_wallets_updated_at
  before update on wallets
  for each row
  execute function update_wallet_timestamp();
