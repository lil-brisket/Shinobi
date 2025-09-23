# ShogunX Banking System

A comprehensive banking system implementation with PostgreSQL database, TypeScript backend APIs, scheduled jobs, and Flutter UI.

## Architecture Overview

### Database Layer
- **PostgreSQL** with Supabase-style schema
- Atomic transactions for all balance changes
- Idempotency keys for request safety
- Comprehensive audit trail

### Backend APIs
- **TypeScript/Node.js** with Express
- RESTful API design
- Rate limiting and validation
- Authentication middleware

### Scheduled Jobs
- **Daily interest offers** at 00:00 UTC
- Configurable interest rates
- Automatic cleanup of expired offers

### Flutter UI
- **Single-page sectioned design** (no tabs)
- Material 3 design system
- Real-time balance updates
- Debounced user search

## Features

### Core Banking Operations
- ✅ **Deposit**: Pocket → Bank transfers
- ✅ **Withdraw**: Bank → Pocket transfers  
- ✅ **Transfer**: Player-to-player transfers
- ✅ **Interest Claims**: Daily interest system
- ✅ **Ledger**: Transaction history
- ✅ **Admin Tools**: CSV export, filtering

### Security & Reliability
- ✅ **Idempotency**: Prevents duplicate transactions
- ✅ **Rate Limiting**: Transfer and claim limits
- ✅ **Balance Guards**: No negative balances
- ✅ **Atomic Operations**: Database transactions
- ✅ **Input Validation**: Comprehensive validation

## Setup Instructions

### 1. Database Setup

```bash
# Create PostgreSQL database
createdb shogunx_banking

# Run migration
psql shogunx_banking < database/migrations/001_banking_system.sql
```

### 2. Backend Setup

```bash
cd backend

# Install dependencies
npm install

# Copy environment file
cp env.example .env

# Edit .env with your database credentials
# DATABASE_URL=postgresql://username:password@localhost:5432/shogunx_banking

# Build TypeScript
npm run build

# Start server
npm start

# Or run in development
npm run dev
```

### 3. Flutter Setup

```bash
# Install Flutter dependencies
flutter pub get

# Generate code (for Freezed models)
flutter packages pub run build_runner build

# Run the app
flutter run
```

### 4. Testing

```bash
# Backend tests
cd backend
npm test

# Flutter tests
flutter test
```

## API Endpoints

### Authentication
All endpoints require `Authorization: Bearer <token>` header.

### Banking Operations

#### POST /api/deposit
```json
{
  "amount": 1000,
  "memo": "Optional note",
  "idempotencyKey": "uuid-v4"
}
```

#### POST /api/withdraw
```json
{
  "amount": 500,
  "memo": "Optional note", 
  "idempotencyKey": "uuid-v4"
}
```

#### POST /api/transfer
```json
{
  "source": "POCKET",
  "toUsername": "recipient",
  "amount": 100,
  "memo": "Optional note",
  "idempotencyKey": "uuid-v4"
}
```

#### POST /api/interest/claim
```json
{
  "offerId": 123,
  "idempotencyKey": "uuid-v4"
}
```

### Query Endpoints

#### GET /api/users/search?q=username
Returns up to 10 matching usernames.

#### GET /api/ledger?limit=50&cursor=...
Returns player's transaction history.

#### GET /api/ledger/admin?...
Admin-only endpoint with filtering options.

## Database Schema

### Tables

#### players
- `id` (UUID, Primary Key)
- `username` (Text, Unique)
- `created_at` (Timestamp)

#### wallets
- `player_id` (UUID, Foreign Key)
- `pocket_balance` (BigInt, ≥ 0)
- `bank_balance` (BigInt, ≥ 0)
- `updated_at` (Timestamp)

#### transactions
- `id` (BigSerial, Primary Key)
- `actor_id` (UUID, Foreign Key)
- `sender_id` (UUID, Foreign Key)
- `receiver_id` (UUID, Foreign Key)
- `source` (Text: 'POCKET'|'BANK')
- `destination` (Text: 'POCKET'|'BANK')
- `amount` (BigInt, > 0)
- `kind` (Text: Transaction type)
- `memo` (Text, Optional)
- `idempotency_key` (Text, Unique)

#### interest_offers
- `id` (BigSerial, Primary Key)
- `player_id` (UUID, Foreign Key)
- `for_date` (Date)
- `bank_balance_snapshot` (BigInt)
- `rate_bps` (Integer)
- `amount` (BigInt)
- `claim_deadline` (Timestamp)
- `claimed_at` (Timestamp, Optional)

## Flutter UI Sections

### A) Balances
- Pocket and Bank balance display
- Large, monospace numbers
- Color-coded by balance type

### B) Deposit
- Amount input with validation
- Optional memo field
- Real-time balance checking

### C) Withdraw
- Amount input with validation
- Optional memo field
- Sufficient balance validation

### D) Transfer
- Source selector (Pocket/Bank)
- Debounced user search (300ms)
- Amount and memo inputs
- Minimum transfer validation

### E) Interest
- Today's offer display
- Claim deadline countdown
- Claim status (Available/Claimed/Expired)
- One-click claiming

### F) My Ledger
- Paginated transaction list
- Compact entry display
- Refresh functionality
- Infinite scroll support

### G) Admin Ledger
- Advanced filtering options
- CSV export functionality
- Admin-only access control

## Configuration

### Environment Variables

```bash
# Database
DATABASE_URL=postgresql://user:pass@localhost:5432/shogunx_banking
DB_HOST=localhost
DB_PORT=5432
DB_NAME=shogunx_banking
DB_USER=username
DB_PASSWORD=password

# Server
PORT=3000
NODE_ENV=development

# Security
JWT_SECRET=your-jwt-secret-key
RATE_LIMIT_WINDOW_MS=60000
RATE_LIMIT_MAX_REQUESTS=100

# Banking
INTEREST_RATE_BPS=1000  # 10%
MIN_TRANSFER_AMOUNT=10
```

## Rate Limits

- **General API**: 100 requests/minute
- **Transfers**: 10 transfers/minute per player
- **Interest Claims**: 1 claim/minute per player

## Error Handling

All API responses follow this format:

```json
{
  "success": false,
  "error": "Error message",
  "data": null
}
```

Common error scenarios:
- Insufficient balance
- Invalid amounts
- Idempotency key conflicts
- Rate limit exceeded
- Authentication required

## Testing

### Backend Tests
- Unit tests for banking service
- Idempotency testing
- Balance validation
- Transfer safety
- Interest claim logic

### Flutter Tests
- Widget tests for UI components
- Provider state management
- Form validation
- Error handling

## Deployment

### Production Considerations
- Use connection pooling for database
- Enable SSL for database connections
- Set up proper logging
- Configure rate limiting
- Use environment-specific configs
- Set up monitoring and alerts

### Docker Support
```dockerfile
# Backend Dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY dist ./dist
EXPOSE 3000
CMD ["node", "dist/index.js"]
```

## Contributing

1. Follow TypeScript best practices
2. Write comprehensive tests
3. Use conventional commit messages
4. Update documentation
5. Ensure all tests pass

## License

This banking system is part of the ShogunX game project.
