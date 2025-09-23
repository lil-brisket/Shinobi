export interface Player {
  id: string;
  username: string;
  created_at: Date;
}

export interface Wallet {
  player_id: string;
  pocket_balance: number;
  bank_balance: number;
  updated_at: Date;
}

export interface Transaction {
  id: number;
  created_at: Date;
  actor_id?: string;
  sender_id?: string;
  receiver_id?: string;
  source: 'POCKET' | 'BANK';
  destination: 'POCKET' | 'BANK';
  amount: number;
  kind: 'DEPOSIT' | 'WITHDRAW' | 'TRANSFER_SEND' | 'TRANSFER_RECEIVE' | 'INTEREST_CLAIM' | 'ADMIN_ADJUST';
  memo?: string;
  idempotency_key?: string;
}

export interface InterestOffer {
  id: number;
  player_id: string;
  for_date: string;
  bank_balance_snapshot: number;
  rate_bps: number;
  amount: number;
  claim_deadline: Date;
  claimed_at?: Date;
  created_at: Date;
}

export interface DepositRequest {
  amount: number;
  memo?: string;
  idempotencyKey: string;
}

export interface WithdrawRequest {
  amount: number;
  memo?: string;
  idempotencyKey: string;
}

export interface TransferRequest {
  source: 'POCKET' | 'BANK';
  toUsername: string;
  amount: number;
  memo?: string;
  idempotencyKey: string;
}

export interface InterestClaimRequest {
  offerId: number;
  idempotencyKey: string;
}

export interface LedgerEntry {
  id: number;
  created_at: Date;
  kind: string;
  amount: number;
  delta: number; // + or - for display
  source: string;
  destination: string;
  counterparty_username?: string;
  memo?: string;
}

export interface AdminLedgerFilters {
  sender?: string;
  receiver?: string;
  from?: string;
  to?: string;
  kind?: string;
  min?: number;
  max?: number;
  limit?: number;
  cursor?: string;
}

export interface ApiResponse<T = any> {
  success: boolean;
  data?: T;
  error?: string;
  message?: string;
}

export interface BalanceResponse {
  pocketBalance: number;
  bankBalance: number;
  txId: number;
}

export interface TransferResponse {
  pocketBalance: number;
  bankBalance: number;
  receipt: {
    counterparty: string;
    amount: number;
    source: string;
    destination: string;
  };
}

export interface InterestClaimResponse {
  bankBalance: number;
  claimedAmount: number;
}
