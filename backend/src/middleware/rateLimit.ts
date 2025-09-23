import rateLimit from 'express-rate-limit';

// General rate limiting
export const generalRateLimit = rateLimit({
  windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS || '60000'), // 1 minute
  max: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS || '100'), // 100 requests per window
  message: {
    success: false,
    error: 'Too many requests, please try again later'
  },
  standardHeaders: true,
  legacyHeaders: false,
});

// Transfer-specific rate limiting (10 per minute)
export const transferRateLimit = rateLimit({
  windowMs: 60 * 1000, // 1 minute
  max: 10, // 10 transfers per minute
  message: {
    success: false,
    error: 'Transfer rate limit exceeded. Maximum 10 transfers per minute.'
  },
  standardHeaders: true,
  legacyHeaders: false,
  keyGenerator: (req) => {
    // Rate limit per player
    const authReq = req as any;
    return authReq.playerId || req.ip;
  }
});

// Interest claim rate limiting (1 per minute)
export const interestRateLimit = rateLimit({
  windowMs: 60 * 1000, // 1 minute
  max: 1, // 1 claim per minute
  message: {
    success: false,
    error: 'Interest claim rate limit exceeded. Maximum 1 claim per minute.'
  },
  standardHeaders: true,
  legacyHeaders: false,
  keyGenerator: (req) => {
    const authReq = req as any;
    return authReq.playerId || req.ip;
  }
});
