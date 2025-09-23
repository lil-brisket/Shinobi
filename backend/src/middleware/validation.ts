import { Request, Response, NextFunction } from 'express';
import { body, query, validationResult } from 'express-validator';
import { ApiResponse } from '../types/banking';

export const handleValidationErrors = (req: Request, res: Response<ApiResponse>, next: NextFunction) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({
      success: false,
      error: 'Validation failed',
      data: errors.array()
    });
  }
  next();
};

export const validateDeposit = [
  body('amount').isInt({ min: 1 }).withMessage('Amount must be a positive integer'),
  body('memo').optional().isString().isLength({ max: 255 }).withMessage('Memo must be a string with max 255 characters'),
  body('idempotencyKey').isUUID().withMessage('Idempotency key must be a valid UUID'),
  handleValidationErrors
];

export const validateWithdraw = [
  body('amount').isInt({ min: 1 }).withMessage('Amount must be a positive integer'),
  body('memo').optional().isString().isLength({ max: 255 }).withMessage('Memo must be a string with max 255 characters'),
  body('idempotencyKey').isUUID().withMessage('Idempotency key must be a valid UUID'),
  handleValidationErrors
];

export const validateTransfer = [
  body('source').isIn(['BANK']).withMessage('Source must be BANK (bank-to-bank transfers only)'),
  body('toUsername').isString().isLength({ min: 1, max: 50 }).withMessage('Username must be 1-50 characters'),
  body('amount').isInt({ min: 1 }).withMessage('Amount must be a positive integer'),
  body('memo').optional().isString().isLength({ max: 255 }).withMessage('Memo must be a string with max 255 characters'),
  body('idempotencyKey').isUUID().withMessage('Idempotency key must be a valid UUID'),
  handleValidationErrors
];

export const validateInterestClaim = [
  body('offerId').isInt({ min: 1 }).withMessage('Offer ID must be a positive integer'),
  body('idempotencyKey').isUUID().withMessage('Idempotency key must be a valid UUID'),
  handleValidationErrors
];

export const validateUserSearch = [
  query('q').isString().isLength({ min: 1, max: 50 }).withMessage('Query must be 1-50 characters'),
  handleValidationErrors
];

export const validateLedgerQuery = [
  query('limit').optional().isInt({ min: 1, max: 100 }).withMessage('Limit must be between 1 and 100'),
  query('cursor').optional().isString().withMessage('Cursor must be a string'),
  handleValidationErrors
];

export const validateAdminLedgerQuery = [
  query('sender').optional().isString().isLength({ max: 50 }).withMessage('Sender must be max 50 characters'),
  query('receiver').optional().isString().isLength({ max: 50 }).withMessage('Receiver must be max 50 characters'),
  query('from').optional().isISO8601().withMessage('From date must be valid ISO8601 format'),
  query('to').optional().isISO8601().withMessage('To date must be valid ISO8601 format'),
  query('kind').optional().isString().withMessage('Kind must be a string'),
  query('min').optional().isInt({ min: 0 }).withMessage('Min amount must be non-negative'),
  query('max').optional().isInt({ min: 0 }).withMessage('Max amount must be non-negative'),
  query('limit').optional().isInt({ min: 1, max: 1000 }).withMessage('Limit must be between 1 and 1000'),
  query('cursor').optional().isString().withMessage('Cursor must be a string'),
  handleValidationErrors
];
