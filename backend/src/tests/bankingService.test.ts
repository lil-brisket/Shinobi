import { BankingService } from '../services/bankingService';
import { db } from '../database/connection';

// Mock the database connection
jest.mock('../database/connection', () => ({
  db: {
    query: jest.fn(),
    transaction: jest.fn(),
  },
}));

describe('BankingService', () => {
  let bankingService: BankingService;
  const mockPlayerId = 'test-player-123';
  const mockReceiverId = 'test-receiver-456';

  beforeEach(() => {
    bankingService = BankingService.getInstance();
    jest.clearAllMocks();
  });

  describe('Deposit', () => {
    it('should successfully deposit from pocket to bank', async () => {
      const mockWallet = {
        player_id: mockPlayerId,
        pocket_balance: 1000,
        bank_balance: 500,
        updated_at: new Date(),
      };

      const mockTransaction = {
        id: 1,
        created_at: new Date(),
        actor_id: mockPlayerId,
        sender_id: mockPlayerId,
        source: 'POCKET',
        destination: 'BANK',
        amount: 100,
        kind: 'DEPOSIT',
        memo: 'Test deposit',
        idempotency_key: 'test-key-1',
      };

      (db.query as jest.Mock).mockImplementation((query: string, params: any[]) => {
        if (query.includes('SELECT * FROM transactions WHERE idempotency_key')) {
          return { rows: [] }; // No existing transaction
        }
        if (query.includes('SELECT * FROM wallets WHERE player_id')) {
          return { rows: [mockWallet] };
        }
        if (query.includes('UPDATE wallets SET pocket_balance')) {
          return { rows: [{ ...mockWallet, pocket_balance: 900, bank_balance: 600 }] };
        }
        if (query.includes('INSERT INTO transactions')) {
          return { rows: [{ id: 1 }] };
        }
        return { rows: [] };
      });

      (db.transaction as jest.Mock).mockImplementation(async (callback) => {
        return await callback({
          query: db.query,
        });
      });

      const result = await bankingService.deposit(mockPlayerId, {
        amount: 100,
        memo: 'Test deposit',
        idempotencyKey: 'test-key-1',
      });

      expect(result.pocketBalance).toBe(900);
      expect(result.bankBalance).toBe(600);
      expect(result.txId).toBe(1);
    });

    it('should prevent negative balances', async () => {
      const mockWallet = {
        player_id: mockPlayerId,
        pocket_balance: 50,
        bank_balance: 500,
        updated_at: new Date(),
      };

      (db.query as jest.Mock).mockImplementation((query: string, params: any[]) => {
        if (query.includes('SELECT * FROM transactions WHERE idempotency_key')) {
          return { rows: [] };
        }
        if (query.includes('SELECT * FROM wallets WHERE player_id')) {
          return { rows: [mockWallet] };
        }
        return { rows: [] };
      });

      (db.transaction as jest.Mock).mockImplementation(async (callback) => {
        return await callback({
          query: db.query,
        });
      });

      await expect(
        bankingService.deposit(mockPlayerId, {
          amount: 100,
          memo: 'Test deposit',
          idempotencyKey: 'test-key-2',
        })
      ).rejects.toThrow('Insufficient pocket balance');
    });

    it('should handle idempotency correctly', async () => {
      const mockTransaction = {
        id: 1,
        created_at: new Date(),
        actor_id: mockPlayerId,
        sender_id: mockPlayerId,
        source: 'POCKET',
        destination: 'BANK',
        amount: 100,
        kind: 'DEPOSIT',
        memo: 'Test deposit',
        idempotency_key: 'test-key-3',
      };

      const mockWallet = {
        player_id: mockPlayerId,
        pocket_balance: 900,
        bank_balance: 600,
        updated_at: new Date(),
      };

      (db.query as jest.Mock).mockImplementation((query: string, params: any[]) => {
        if (query.includes('SELECT * FROM transactions WHERE idempotency_key')) {
          return { rows: [mockTransaction] };
        }
        if (query.includes('SELECT * FROM wallets WHERE player_id')) {
          return { rows: [mockWallet] };
        }
        return { rows: [] };
      });

      (db.transaction as jest.Mock).mockImplementation(async (callback) => {
        return await callback({
          query: db.query,
        });
      });

      const result = await bankingService.deposit(mockPlayerId, {
        amount: 100,
        memo: 'Test deposit',
        idempotencyKey: 'test-key-3',
      });

      expect(result.pocketBalance).toBe(900);
      expect(result.bankBalance).toBe(600);
      expect(result.txId).toBe(1);
    });

    it('should reject idempotency key conflicts', async () => {
      const mockTransaction = {
        id: 1,
        created_at: new Date(),
        actor_id: 'different-player',
        sender_id: 'different-player',
        source: 'POCKET',
        destination: 'BANK',
        amount: 100,
        kind: 'DEPOSIT',
        memo: 'Test deposit',
        idempotency_key: 'test-key-4',
      };

      (db.query as jest.Mock).mockImplementation((query: string, params: any[]) => {
        if (query.includes('SELECT * FROM transactions WHERE idempotency_key')) {
          return { rows: [mockTransaction] };
        }
        return { rows: [] };
      });

      (db.transaction as jest.Mock).mockImplementation(async (callback) => {
        return await callback({
          query: db.query,
        });
      });

      await expect(
        bankingService.deposit(mockPlayerId, {
          amount: 100,
          memo: 'Test deposit',
          idempotencyKey: 'test-key-4',
        })
      ).rejects.toThrow('Idempotency key conflict');
    });
  });

  describe('Transfer', () => {
    it('should successfully transfer between players', async () => {
      const mockSenderWallet = {
        player_id: mockPlayerId,
        pocket_balance: 1000,
        bank_balance: 500,
        updated_at: new Date(),
      };

      const mockReceiver = {
        id: mockReceiverId,
        username: 'testreceiver',
      };

      const mockReceiverWallet = {
        player_id: mockReceiverId,
        pocket_balance: 0,
        bank_balance: 200,
        updated_at: new Date(),
      };

      (db.query as jest.Mock).mockImplementation((query: string, params: any[]) => {
        if (query.includes('SELECT * FROM transactions WHERE idempotency_key')) {
          return { rows: [] };
        }
        if (query.includes('SELECT id, username FROM players WHERE username')) {
          return { rows: [mockReceiver] };
        }
        if (query.includes('SELECT * FROM wallets WHERE player_id') && params[0] === mockPlayerId) {
          return { rows: [mockSenderWallet] };
        }
        if (query.includes('SELECT * FROM wallets WHERE player_id') && params[0] === mockReceiverId) {
          return { rows: [mockReceiverWallet] };
        }
        if (query.includes('UPDATE wallets SET pocket_balance = pocket_balance -')) {
          return { rows: [{ ...mockSenderWallet, pocket_balance: 900 }] };
        }
        if (query.includes('UPDATE wallets SET bank_balance = bank_balance +') && params[1] === mockReceiverId) {
          return { rows: [{ ...mockReceiverWallet, bank_balance: 300 }] };
        }
        return { rows: [] };
      });

      (db.transaction as jest.Mock).mockImplementation(async (callback) => {
        return await callback({
          query: db.query,
        });
      });

      const result = await bankingService.transfer(mockPlayerId, {
        source: 'POCKET',
        toUsername: 'testreceiver',
        amount: 100,
        memo: 'Test transfer',
        idempotencyKey: 'test-key-5',
      });

      expect(result.pocketBalance).toBe(900);
      expect(result.bankBalance).toBe(500);
      expect(result.receipt.counterparty).toBe('testreceiver');
      expect(result.receipt.amount).toBe(100);
      expect(result.receipt.source).toBe('POCKET');
      expect(result.receipt.destination).toBe('BANK');
    });

    it('should enforce minimum transfer amount', async () => {
      const mockSenderWallet = {
        player_id: mockPlayerId,
        pocket_balance: 1000,
        bank_balance: 500,
        updated_at: new Date(),
      };

      const mockReceiver = {
        id: mockReceiverId,
        username: 'testreceiver',
      };

      (db.query as jest.Mock).mockImplementation((query: string, params: any[]) => {
        if (query.includes('SELECT * FROM transactions WHERE idempotency_key')) {
          return { rows: [] };
        }
        if (query.includes('SELECT id, username FROM players WHERE username')) {
          return { rows: [mockReceiver] };
        }
        if (query.includes('SELECT * FROM wallets WHERE player_id')) {
          return { rows: [mockSenderWallet] };
        }
        return { rows: [] };
      });

      (db.transaction as jest.Mock).mockImplementation(async (callback) => {
        return await callback({
          query: db.query,
        });
      });

      await expect(
        bankingService.transfer(mockPlayerId, {
          source: 'POCKET',
          toUsername: 'testreceiver',
          amount: 5, // Below minimum
          memo: 'Test transfer',
          idempotencyKey: 'test-key-6',
        })
      ).rejects.toThrow('Minimum transfer amount is 10 ryo');
    });

    it('should prevent double-submit transfers', async () => {
      const mockTransaction = {
        id: 1,
        created_at: new Date(),
        actor_id: mockPlayerId,
        sender_id: mockPlayerId,
        receiver_id: mockReceiverId,
        source: 'POCKET',
        destination: 'BANK',
        amount: 100,
        kind: 'TRANSFER_SEND',
        memo: 'Test transfer',
        idempotency_key: 'test-key-7',
      };

      const mockWallet = {
        player_id: mockPlayerId,
        pocket_balance: 900,
        bank_balance: 500,
        updated_at: new Date(),
      };

      (db.query as jest.Mock).mockImplementation((query: string, params: any[]) => {
        if (query.includes('SELECT * FROM transactions WHERE idempotency_key')) {
          return { rows: [mockTransaction] };
        }
        if (query.includes('SELECT * FROM wallets WHERE player_id')) {
          return { rows: [mockWallet] };
        }
        return { rows: [] };
      });

      (db.transaction as jest.Mock).mockImplementation(async (callback) => {
        return await callback({
          query: db.query,
        });
      });

      const result = await bankingService.transfer(mockPlayerId, {
        source: 'POCKET',
        toUsername: 'testreceiver',
        amount: 100,
        memo: 'Test transfer',
        idempotencyKey: 'test-key-7',
      });

      expect(result.pocketBalance).toBe(900);
      expect(result.bankBalance).toBe(500);
      expect(result.receipt.counterparty).toBe('testreceiver');
    });
  });

  describe('Interest Claims', () => {
    it('should successfully claim interest before deadline', async () => {
      const mockOffer = {
        id: 1,
        player_id: mockPlayerId,
        for_date: '2024-01-01',
        bank_balance_snapshot: 1000,
        rate_bps: 1000,
        amount: 100,
        claim_deadline: new Date(Date.now() + 24 * 60 * 60 * 1000), // 24 hours from now
        claimed_at: null,
        created_at: new Date(),
      };

      const mockWallet = {
        player_id: mockPlayerId,
        pocket_balance: 0,
        bank_balance: 1000,
        updated_at: new Date(),
      };

      (db.query as jest.Mock).mockImplementation((query: string, params: any[]) => {
        if (query.includes('SELECT * FROM transactions WHERE idempotency_key')) {
          return { rows: [] };
        }
        if (query.includes('SELECT * FROM interest_offers WHERE id')) {
          return { rows: [mockOffer] };
        }
        if (query.includes('SELECT * FROM wallets WHERE player_id')) {
          return { rows: [mockWallet] };
        }
        if (query.includes('UPDATE wallets SET bank_balance = bank_balance +')) {
          return { rows: [{ ...mockWallet, bank_balance: 1100 }] };
        }
        return { rows: [] };
      });

      (db.transaction as jest.Mock).mockImplementation(async (callback) => {
        return await callback({
          query: db.query,
        });
      });

      const result = await bankingService.claimInterest(mockPlayerId, {
        offerId: 1,
        idempotencyKey: 'test-key-8',
      });

      expect(result.bankBalance).toBe(1100);
      expect(result.claimedAmount).toBe(100);
    });

    it('should reject expired interest claims', async () => {
      const mockOffer = {
        id: 1,
        player_id: mockPlayerId,
        for_date: '2024-01-01',
        bank_balance_snapshot: 1000,
        rate_bps: 1000,
        amount: 100,
        claim_deadline: new Date(Date.now() - 24 * 60 * 60 * 1000), // 24 hours ago
        claimed_at: null,
        created_at: new Date(),
      };

      (db.query as jest.Mock).mockImplementation((query: string, params: any[]) => {
        if (query.includes('SELECT * FROM transactions WHERE idempotency_key')) {
          return { rows: [] };
        }
        if (query.includes('SELECT * FROM interest_offers WHERE id')) {
          return { rows: [mockOffer] };
        }
        return { rows: [] };
      });

      (db.transaction as jest.Mock).mockImplementation(async (callback) => {
        return await callback({
          query: db.query,
        });
      });

      await expect(
        bankingService.claimInterest(mockPlayerId, {
          offerId: 1,
          idempotencyKey: 'test-key-9',
        })
      ).rejects.toThrow('Interest offer has expired');
    });

    it('should reject already claimed interest', async () => {
      const mockOffer = {
        id: 1,
        player_id: mockPlayerId,
        for_date: '2024-01-01',
        bank_balance_snapshot: 1000,
        rate_bps: 1000,
        amount: 100,
        claim_deadline: new Date(Date.now() + 24 * 60 * 60 * 1000),
        claimed_at: new Date(),
        created_at: new Date(),
      };

      (db.query as jest.Mock).mockImplementation((query: string, params: any[]) => {
        if (query.includes('SELECT * FROM transactions WHERE idempotency_key')) {
          return { rows: [] };
        }
        if (query.includes('SELECT * FROM interest_offers WHERE id')) {
          return { rows: [mockOffer] };
        }
        return { rows: [] };
      });

      (db.transaction as jest.Mock).mockImplementation(async (callback) => {
        return await callback({
          query: db.query,
        });
      });

      await expect(
        bankingService.claimInterest(mockPlayerId, {
          offerId: 1,
          idempotencyKey: 'test-key-10',
        })
      ).rejects.toThrow('Interest already claimed');
    });
  });

  describe('Daily Interest Offers', () => {
    it('should create daily interest offers for players with bank balance', async () => {
      const mockWallets = [
        { player_id: 'player1', bank_balance: 1000 },
        { player_id: 'player2', bank_balance: 500 },
        { player_id: 'player3', bank_balance: 0 }, // Should be skipped
      ];

      (db.query as jest.Mock).mockImplementation((query: string, params: any[]) => {
        if (query.includes('SELECT player_id, bank_balance FROM wallets WHERE bank_balance > 0')) {
          return { rows: mockWallets.slice(0, 2) }; // Only players with balance > 0
        }
        if (query.includes('INSERT INTO interest_offers')) {
          return { rows: [] };
        }
        return { rows: [] };
      });

      await bankingService.createDailyInterestOffers();

      // Should call INSERT for each player with balance > 0
      expect(db.query).toHaveBeenCalledWith(
        expect.stringContaining('INSERT INTO interest_offers'),
        expect.arrayContaining([
          'player1',
          expect.any(String), // for_date
          1000, // bank_balance_snapshot
          1000, // rate_bps
          100, // amount (10% of 1000)
          expect.any(Date), // claim_deadline
        ])
      );

      expect(db.query).toHaveBeenCalledWith(
        expect.stringContaining('INSERT INTO interest_offers'),
        expect.arrayContaining([
          'player2',
          expect.any(String), // for_date
          500, // bank_balance_snapshot
          1000, // rate_bps
          50, // amount (10% of 500)
          expect.any(Date), // claim_deadline
        ])
      );
    });
  });
});
