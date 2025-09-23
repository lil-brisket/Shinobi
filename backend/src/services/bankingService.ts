import { v4 as uuidv4 } from 'uuid';
import { db } from '../database/connection';
import {
  Player,
  Wallet,
  Transaction,
  InterestOffer,
  DepositRequest,
  WithdrawRequest,
  TransferRequest,
  InterestClaimRequest,
  LedgerEntry,
  AdminLedgerFilters,
  BalanceResponse,
  TransferResponse,
  InterestClaimResponse
} from '../types/banking';

export class BankingService {
  private static instance: BankingService;

  private constructor() {}

  public static getInstance(): BankingService {
    if (!BankingService.instance) {
      BankingService.instance = new BankingService();
    }
    return BankingService.instance;
  }

  // Get or create wallet for player
  public async getOrCreateWallet(playerId: string): Promise<Wallet> {
    const result = await db.query(
      'SELECT * FROM wallets WHERE player_id = $1',
      [playerId]
    );

    if (result.rows.length === 0) {
      // Create wallet if it doesn't exist
      const newWallet = await db.query(
        'INSERT INTO wallets (player_id, pocket_balance, bank_balance) VALUES ($1, 0, 0) RETURNING *',
        [playerId]
      );
      return newWallet.rows[0];
    }

    return result.rows[0];
  }

  // Deposit from pocket to bank
  public async deposit(playerId: string, request: DepositRequest): Promise<BalanceResponse> {
    return await db.transaction(async (client) => {
      // Check for idempotency
      const existingTx = await client.query(
        'SELECT * FROM transactions WHERE idempotency_key = $1',
        [request.idempotencyKey]
      );

      if (existingTx.rows.length > 0) {
        const tx = existingTx.rows[0];
        if (tx.actor_id !== playerId || tx.amount !== request.amount) {
          throw new Error('Idempotency key conflict');
        }
        // Return existing transaction result
        const wallet = await this.getOrCreateWallet(playerId);
        return {
          pocketBalance: wallet.pocket_balance,
          bankBalance: wallet.bank_balance,
          txId: tx.id
        };
      }

      // Get current wallet
      const walletResult = await client.query(
        'SELECT * FROM wallets WHERE player_id = $1 FOR UPDATE',
        [playerId]
      );

      if (walletResult.rows.length === 0) {
        throw new Error('Wallet not found');
      }

      const wallet = walletResult.rows[0];

      // Check sufficient balance
      if (wallet.pocket_balance < request.amount) {
        throw new Error('Insufficient pocket balance');
      }

      // Update wallet
      const updatedWallet = await client.query(
        'UPDATE wallets SET pocket_balance = pocket_balance - $1, bank_balance = bank_balance + $1 WHERE player_id = $2 RETURNING *',
        [request.amount, playerId]
      );

      // Insert transaction
      const txResult = await client.query(
        'INSERT INTO transactions (actor_id, sender_id, source, destination, amount, kind, memo, idempotency_key) VALUES ($1, $1, $2, $3, $4, $5, $6, $7) RETURNING id',
        [playerId, 'POCKET', 'BANK', request.amount, 'DEPOSIT', request.memo, request.idempotencyKey]
      );

      return {
        pocketBalance: updatedWallet.rows[0].pocket_balance,
        bankBalance: updatedWallet.rows[0].bank_balance,
        txId: txResult.rows[0].id
      };
    });
  }

  // Withdraw from bank to pocket
  public async withdraw(playerId: string, request: WithdrawRequest): Promise<BalanceResponse> {
    return await db.transaction(async (client) => {
      // Check for idempotency
      const existingTx = await client.query(
        'SELECT * FROM transactions WHERE idempotency_key = $1',
        [request.idempotencyKey]
      );

      if (existingTx.rows.length > 0) {
        const tx = existingTx.rows[0];
        if (tx.actor_id !== playerId || tx.amount !== request.amount) {
          throw new Error('Idempotency key conflict');
        }
        const wallet = await this.getOrCreateWallet(playerId);
        return {
          pocketBalance: wallet.pocket_balance,
          bankBalance: wallet.bank_balance,
          txId: tx.id
        };
      }

      // Get current wallet
      const walletResult = await client.query(
        'SELECT * FROM wallets WHERE player_id = $1 FOR UPDATE',
        [playerId]
      );

      if (walletResult.rows.length === 0) {
        throw new Error('Wallet not found');
      }

      const wallet = walletResult.rows[0];

      // Check sufficient balance
      if (wallet.bank_balance < request.amount) {
        throw new Error('Insufficient bank balance');
      }

      // Update wallet
      const updatedWallet = await client.query(
        'UPDATE wallets SET bank_balance = bank_balance - $1, pocket_balance = pocket_balance + $1 WHERE player_id = $2 RETURNING *',
        [request.amount, playerId]
      );

      // Insert transaction
      const txResult = await client.query(
        'INSERT INTO transactions (actor_id, sender_id, source, destination, amount, kind, memo, idempotency_key) VALUES ($1, $1, $2, $3, $4, $5, $6, $7) RETURNING id',
        [playerId, 'BANK', 'POCKET', request.amount, 'WITHDRAW', request.memo, request.idempotencyKey]
      );

      return {
        pocketBalance: updatedWallet.rows[0].pocket_balance,
        bankBalance: updatedWallet.rows[0].bank_balance,
        txId: txResult.rows[0].id
      };
    });
  }

  // Search users by username
  public async searchUsers(query: string): Promise<Player[]> {
    const result = await db.query(
      'SELECT id, username FROM players WHERE lower(username) LIKE lower($1) ORDER BY username LIMIT 10',
      [`${query}%`]
    );
    return result.rows;
  }

  // Transfer between players
  public async transfer(playerId: string, request: TransferRequest): Promise<TransferResponse> {
    return await db.transaction(async (client) => {
      // Check for idempotency
      const existingTx = await client.query(
        'SELECT * FROM transactions WHERE idempotency_key = $1',
        [request.idempotencyKey]
      );

      if (existingTx.rows.length > 0) {
        const tx = existingTx.rows[0];
        if (tx.actor_id !== playerId || tx.amount !== request.amount) {
          throw new Error('Idempotency key conflict');
        }
        const wallet = await this.getOrCreateWallet(playerId);
        return {
          pocketBalance: wallet.pocket_balance,
          bankBalance: wallet.bank_balance,
          receipt: {
            counterparty: request.toUsername,
            amount: request.amount,
            source: request.source,
            destination: 'BANK'
          }
        };
      }

      // Find receiver
      const receiverResult = await client.query(
        'SELECT id, username FROM players WHERE username = $1',
        [request.toUsername]
      );

      if (receiverResult.rows.length === 0) {
        throw new Error('Receiver not found');
      }

      const receiver = receiverResult.rows[0];

      // Get sender wallet
      const senderWalletResult = await client.query(
        'SELECT * FROM wallets WHERE player_id = $1 FOR UPDATE',
        [playerId]
      );

      if (senderWalletResult.rows.length === 0) {
        throw new Error('Sender wallet not found');
      }

      const senderWallet = senderWalletResult.rows[0];

      // Check sufficient balance
      const sourceBalance = request.source === 'POCKET' ? senderWallet.pocket_balance : senderWallet.bank_balance;
      if (sourceBalance < request.amount) {
        throw new Error(`Insufficient ${request.source.toLowerCase()} balance`);
      }

      // Check minimum transfer amount
      const minTransfer = parseInt(process.env.MIN_TRANSFER_AMOUNT || '10');
      if (request.amount < minTransfer) {
        throw new Error(`Minimum transfer amount is ${minTransfer} ryo`);
      }

      // Get or create receiver wallet
      const receiverWalletResult = await client.query(
        'SELECT * FROM wallets WHERE player_id = $1 FOR UPDATE',
        [receiver.id]
      );

      let receiverWallet;
      if (receiverWalletResult.rows.length === 0) {
        const newWallet = await client.query(
          'INSERT INTO wallets (player_id, pocket_balance, bank_balance) VALUES ($1, 0, 0) RETURNING *',
          [receiver.id]
        );
        receiverWallet = newWallet.rows[0];
      } else {
        receiverWallet = receiverWalletResult.rows[0];
      }

      // Update sender wallet
      const senderUpdateQuery = request.source === 'POCKET' 
        ? 'UPDATE wallets SET pocket_balance = pocket_balance - $1 WHERE player_id = $2 RETURNING *'
        : 'UPDATE wallets SET bank_balance = bank_balance - $1 WHERE player_id = $2 RETURNING *';
      
      const updatedSenderWallet = await client.query(senderUpdateQuery, [request.amount, playerId]);

      // Update receiver wallet (always goes to bank)
      const updatedReceiverWallet = await client.query(
        'UPDATE wallets SET bank_balance = bank_balance + $1 WHERE player_id = $2 RETURNING *',
        [request.amount, receiver.id]
      );

      // Insert transaction record
      await client.query(
        'INSERT INTO transactions (actor_id, sender_id, receiver_id, source, destination, amount, kind, memo, idempotency_key) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)',
        [playerId, playerId, receiver.id, request.source, 'BANK', request.amount, 'TRANSFER_SEND', request.memo, request.idempotencyKey]
      );

      return {
        pocketBalance: updatedSenderWallet.rows[0].pocket_balance,
        bankBalance: updatedSenderWallet.rows[0].bank_balance,
        receipt: {
          counterparty: request.toUsername,
          amount: request.amount,
          source: request.source,
          destination: 'BANK'
        }
      };
    });
  }

  // Get today's interest offer
  public async getTodaysInterestOffer(playerId: string): Promise<InterestOffer | null> {
    const today = new Date().toISOString().split('T')[0];
    const result = await db.query(
      'SELECT * FROM interest_offers WHERE player_id = $1 AND for_date = $2',
      [playerId, today]
    );
    return result.rows[0] || null;
  }

  // Claim interest
  public async claimInterest(playerId: string, request: InterestClaimRequest): Promise<InterestClaimResponse> {
    return await db.transaction(async (client) => {
      // Check for idempotency
      const existingTx = await client.query(
        'SELECT * FROM transactions WHERE idempotency_key = $1',
        [request.idempotencyKey]
      );

      if (existingTx.rows.length > 0) {
        const tx = existingTx.rows[0];
        if (tx.actor_id !== playerId || tx.kind !== 'INTEREST_CLAIM') {
          throw new Error('Idempotency key conflict');
        }
        const wallet = await this.getOrCreateWallet(playerId);
        return {
          bankBalance: wallet.bank_balance,
          claimedAmount: tx.amount
        };
      }

      // Get interest offer
      const offerResult = await client.query(
        'SELECT * FROM interest_offers WHERE id = $1 AND player_id = $2 FOR UPDATE',
        [request.offerId, playerId]
      );

      if (offerResult.rows.length === 0) {
        throw new Error('Interest offer not found');
      }

      const offer = offerResult.rows[0];

      // Check if already claimed
      if (offer.claimed_at) {
        throw new Error('Interest already claimed');
      }

      // Check if expired
      if (new Date() > new Date(offer.claim_deadline)) {
        throw new Error('Interest offer has expired');
      }

      // Update wallet
      const updatedWallet = await client.query(
        'UPDATE wallets SET bank_balance = bank_balance + $1 WHERE player_id = $2 RETURNING *',
        [offer.amount, playerId]
      );

      // Mark offer as claimed
      await client.query(
        'UPDATE interest_offers SET claimed_at = NOW() WHERE id = $1',
        [request.offerId]
      );

      // Insert transaction
      await client.query(
        'INSERT INTO transactions (actor_id, sender_id, source, destination, amount, kind, idempotency_key) VALUES ($1, $1, $2, $3, $4, $5, $6)',
        [playerId, 'BANK', 'BANK', offer.amount, 'INTEREST_CLAIM', request.idempotencyKey]
      );

      return {
        bankBalance: updatedWallet.rows[0].bank_balance,
        claimedAmount: offer.amount
      };
    });
  }

  // Get player ledger
  public async getPlayerLedger(playerId: string, limit: number = 50, cursor?: string): Promise<LedgerEntry[]> {
    let query = `
      SELECT 
        t.id,
        t.created_at,
        t.kind,
        t.amount,
        CASE 
          WHEN t.sender_id = $1 THEN -t.amount
          ELSE t.amount
        END as delta,
        t.source,
        t.destination,
        CASE 
          WHEN t.sender_id = $1 THEN p2.username
          ELSE p1.username
        END as counterparty_username,
        t.memo
      FROM transactions t
      LEFT JOIN players p1 ON t.sender_id = p1.id
      LEFT JOIN players p2 ON t.receiver_id = p2.id
      WHERE t.sender_id = $1 OR t.receiver_id = $1
    `;

    const params: any[] = [playerId];

    if (cursor) {
      const [createdAt, id] = cursor.split('|');
      query += ` AND (t.created_at < $${params.length + 1} OR (t.created_at = $${params.length + 1} AND t.id < $${params.length + 2}))`;
      params.push(createdAt, parseInt(id));
    }

    query += ` ORDER BY t.created_at DESC, t.id DESC LIMIT $${params.length + 1}`;
    params.push(limit);

    const result = await db.query(query, params);
    return result.rows;
  }

  // Get admin ledger with filters
  public async getAdminLedger(filters: AdminLedgerFilters): Promise<LedgerEntry[]> {
    let query = `
      SELECT 
        t.id,
        t.created_at,
        t.kind,
        t.amount,
        CASE 
          WHEN t.sender_id IS NOT NULL THEN -t.amount
          ELSE t.amount
        END as delta,
        t.source,
        t.destination,
        p1.username as sender_username,
        p2.username as receiver_username,
        t.memo
      FROM transactions t
      LEFT JOIN players p1 ON t.sender_id = p1.id
      LEFT JOIN players p2 ON t.receiver_id = p2.id
      WHERE 1=1
    `;

    const params: any[] = [];
    let paramCount = 0;

    // Apply filters
    if (filters.sender) {
      paramCount++;
      query += ` AND p1.username ILIKE $${paramCount}`;
      params.push(`%${filters.sender}%`);
    }

    if (filters.receiver) {
      paramCount++;
      query += ` AND p2.username ILIKE $${paramCount}`;
      params.push(`%${filters.receiver}%`);
    }

    if (filters.from) {
      paramCount++;
      query += ` AND t.created_at >= $${paramCount}`;
      params.push(filters.from);
    }

    if (filters.to) {
      paramCount++;
      query += ` AND t.created_at <= $${paramCount}`;
      params.push(filters.to);
    }

    if (filters.kind) {
      paramCount++;
      query += ` AND t.kind = $${paramCount}`;
      params.push(filters.kind);
    }

    if (filters.min) {
      paramCount++;
      query += ` AND t.amount >= $${paramCount}`;
      params.push(filters.min);
    }

    if (filters.max) {
      paramCount++;
      query += ` AND t.amount <= $${paramCount}`;
      params.push(filters.max);
    }

    if (filters.cursor) {
      const [createdAt, id] = filters.cursor.split('|');
      paramCount++;
      query += ` AND (t.created_at < $${paramCount} OR (t.created_at = $${paramCount} AND t.id < $${paramCount + 1}))`;
      params.push(createdAt, parseInt(id));
    }

    query += ` ORDER BY t.created_at DESC, t.id DESC`;
    
    if (filters.limit) {
      paramCount++;
      query += ` LIMIT $${paramCount}`;
      params.push(filters.limit);
    } else {
      query += ` LIMIT 100`;
    }

    const result = await db.query(query, params);
    return result.rows;
  }

  // Create daily interest offers (called by cron job)
  public async createDailyInterestOffers(): Promise<void> {
    const yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);
    const forDate = yesterday.toISOString().split('T')[0];

    const rateBps = parseInt(process.env.INTEREST_RATE_BPS || '1000'); // 10%
    const rate = rateBps / 10000;

    // Get all wallets with bank balance > 0
    const walletsResult = await db.query(
      'SELECT player_id, bank_balance FROM wallets WHERE bank_balance > 0'
    );

    for (const wallet of walletsResult.rows) {
      const amount = Math.floor(wallet.bank_balance * rate);
      
      if (amount > 0) {
        // Insert interest offer (ON CONFLICT DO NOTHING handles duplicates)
        await db.query(
          `INSERT INTO interest_offers (player_id, for_date, bank_balance_snapshot, rate_bps, amount, claim_deadline)
           VALUES ($1, $2, $3, $4, $5, $6)
           ON CONFLICT (player_id, for_date) DO NOTHING`,
          [
            wallet.player_id,
            forDate,
            wallet.bank_balance,
            rateBps,
            amount,
            new Date(Date.now() + 24 * 60 * 60 * 1000) // 24 hours from now
          ]
        );
      }
    }
  }
}

export const bankingService = BankingService.getInstance();
