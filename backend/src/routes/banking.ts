import { Router, Response } from 'express';
import { bankingService } from '../services/bankingService';
import { authenticate, AuthenticatedRequest } from '../middleware/auth';
import { requireAdmin } from '../middleware/auth';
import { 
  validateDeposit, 
  validateWithdraw, 
  validateTransfer, 
  validateInterestClaim,
  validateUserSearch,
  validateLedgerQuery,
  validateAdminLedgerQuery
} from '../middleware/validation';
import { transferRateLimit, interestRateLimit } from '../middleware/rateLimit';
import { ApiResponse, DepositRequest, WithdrawRequest, TransferRequest, InterestClaimRequest, AdminLedgerFilters } from '../types/banking';

const router = Router();

// Apply authentication to all routes
router.use(authenticate);

// POST /api/bank/deposit
router.post('/deposit', validateDeposit, async (req: AuthenticatedRequest, res: Response<ApiResponse>) => {
  try {
    const request: DepositRequest = req.body;
    const result = await bankingService.deposit(req.playerId!, request);
    
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      error: error instanceof Error ? error.message : 'Deposit failed'
    });
  }
});

// POST /api/bank/withdraw
router.post('/withdraw', validateWithdraw, async (req: AuthenticatedRequest, res: Response<ApiResponse>) => {
  try {
    const request: WithdrawRequest = req.body;
    const result = await bankingService.withdraw(req.playerId!, request);
    
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      error: error instanceof Error ? error.message : 'Withdraw failed'
    });
  }
});

// GET /api/users/search
router.get('/users/search', validateUserSearch, async (req: AuthenticatedRequest, res: Response<ApiResponse>) => {
  try {
    const query = req.query.q as string;
    const users = await bankingService.searchUsers(query);
    
    res.json({
      success: true,
      data: users
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: 'User search failed'
    });
  }
});

// POST /api/transfer
router.post('/transfer', transferRateLimit, validateTransfer, async (req: AuthenticatedRequest, res: Response<ApiResponse>) => {
  try {
    const request: TransferRequest = req.body;
    const result = await bankingService.transfer(req.playerId!, request);
    
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      error: error instanceof Error ? error.message : 'Transfer failed'
    });
  }
});

// POST /api/interest/claim
router.post('/interest/claim', interestRateLimit, validateInterestClaim, async (req: AuthenticatedRequest, res: Response<ApiResponse>) => {
  try {
    const request: InterestClaimRequest = req.body;
    const result = await bankingService.claimInterest(req.playerId!, request);
    
    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    res.status(400).json({
      success: false,
      error: error instanceof Error ? error.message : 'Interest claim failed'
    });
  }
});

// GET /api/ledger
router.get('/ledger', validateLedgerQuery, async (req: AuthenticatedRequest, res: Response<ApiResponse>) => {
  try {
    const limit = parseInt(req.query.limit as string) || 50;
    const cursor = req.query.cursor as string;
    
    const ledger = await bankingService.getPlayerLedger(req.playerId!, limit, cursor);
    
    res.json({
      success: true,
      data: ledger
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: 'Failed to fetch ledger'
    });
  }
});

// GET /api/ledger/admin
router.get('/ledger/admin', requireAdmin, validateAdminLedgerQuery, async (req: AuthenticatedRequest, res: Response<ApiResponse>) => {
  try {
    const filters: AdminLedgerFilters = {
      sender: req.query.sender as string,
      receiver: req.query.receiver as string,
      from: req.query.from as string,
      to: req.query.to as string,
      kind: req.query.kind as string,
      min: req.query.min ? parseInt(req.query.min as string) : undefined,
      max: req.query.max ? parseInt(req.query.max as string) : undefined,
      limit: req.query.limit ? parseInt(req.query.limit as string) : undefined,
      cursor: req.query.cursor as string
    };

    const ledger = await bankingService.getAdminLedger(filters);
    
    // Check if CSV export is requested
    if (req.headers.accept === 'text/csv') {
      const csv = generateCSV(ledger);
      res.setHeader('Content-Type', 'text/csv');
      res.setHeader('Content-Disposition', 'attachment; filename="ledger.csv"');
      return res.send(csv);
    }
    
    res.json({
      success: true,
      data: ledger
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: 'Failed to fetch admin ledger'
    });
  }
});

// GET /api/interest/offer
router.get('/interest/offer', async (req: AuthenticatedRequest, res: Response<ApiResponse>) => {
  try {
    const offer = await bankingService.getTodaysInterestOffer(req.playerId!);
    
    res.json({
      success: true,
      data: offer
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: 'Failed to fetch interest offer'
    });
  }
});

// Helper function to generate CSV
function generateCSV(ledger: any[]): string {
  const headers = ['ID', 'Date', 'Kind', 'Amount', 'Delta', 'Source', 'Destination', 'Sender', 'Receiver', 'Memo'];
  const rows = ledger.map(entry => [
    entry.id,
    entry.created_at,
    entry.kind,
    entry.amount,
    entry.delta,
    entry.source,
    entry.destination,
    entry.sender_username || '',
    entry.receiver_username || '',
    entry.memo || ''
  ]);

  const csvContent = [headers, ...rows]
    .map(row => row.map(field => `"${field}"`).join(','))
    .join('\n');

  return csvContent;
}

export default router;
