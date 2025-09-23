import { Request, Response, NextFunction } from 'express';
import { ApiResponse } from '../types/banking';

// Mock authentication middleware - replace with actual JWT/session logic
export interface AuthenticatedRequest extends Request {
  playerId?: string;
  isAdmin?: boolean;
}

export const authenticate = (req: AuthenticatedRequest, res: Response<ApiResponse>, next: NextFunction) => {
  // Mock authentication - in real implementation, verify JWT token or session
  const authHeader = req.headers.authorization;
  
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({
      success: false,
      error: 'Authentication required'
    });
  }

  // Mock player ID extraction - replace with actual JWT verification
  const token = authHeader.substring(7);
  
  // For demo purposes, assume token contains player ID
  // In real implementation, verify and decode JWT
  if (token === 'admin-token') {
    req.playerId = 'admin-player-id';
    req.isAdmin = true;
  } else if (token === 'player-token') {
    req.playerId = 'player-123';
    req.isAdmin = false;
  } else {
    return res.status(401).json({
      success: false,
      error: 'Invalid authentication token'
    });
  }

  next();
};

export const requireAdmin = (req: AuthenticatedRequest, res: Response<ApiResponse>, next: NextFunction) => {
  if (!req.isAdmin) {
    return res.status(403).json({
      success: false,
      error: 'Admin privileges required'
    });
  }
  next();
};
