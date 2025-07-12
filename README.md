# STX Betting Smart Contract

A decentralized betting platform built on the Stacks blockchain that allows users to predict STX price movements within specified time frames.

## 🎯 Overview

The **bet-logic-contract** enables users to place bets on whether the STX price will rise or drop within a chosen duration (1 hour to 30 days). The contract features automated resolution, risk management, comprehensive statistics tracking, and a 3% house edge for sustainability.

## 🚀 Features

### 🎲 Core Betting Functionality
- **Price Predictions**: Bet on STX price rising or dropping
- **Flexible Duration**: Choose betting periods from 1 hour to 30 days
- **Automated Payouts**: 2x multiplier for winners (minus house edge)
- **Draw Protection**: Original bet returned if price moves <1%

### 📊 Risk Management
- **Pool Balancing**: Prevents >80% concentration in any prediction type
- **Betting Limits**: 0.1 STX minimum, 100,000 STX maximum
- **Oracle Integration**: Secure price data from authorized sources
- **Emergency Controls**: Pause mechanism and emergency resolution

### 📈 Analytics & Tracking
- **User Statistics**: Win/loss records, streaks, total volume
- **Daily Pools**: Volume tracking by prediction type and date
- **Contract Metrics**: Total bets, volume, house balance
- **Active Bet Monitoring**: Real-time tracking of pending bets

### 🔒 Security Features
- **Access Control**: Owner-only administrative functions
- **Oracle Authorization**: Verified price data sources
- **Input Validation**: Comprehensive parameter checking
- **Pause Mechanism**: Emergency stop functionality

## 🏗️ Contract Architecture

### Constants
```clarity
;; Error codes
ERR_UNAUTHORIZED (u100)
ERR_INVALID_BET_AMOUNT (u101)
ERR_INVALID_DURATION (u102)
// ... more error codes

;; Betting parameters
MIN_BET_AMOUNT: 0.1 STX (u100000 microSTX)
MAX_BET_AMOUNT: 100,000 STX
MIN_DURATION: 1 hour (u3600 seconds)
MAX_DURATION: 30 days (u2592000 seconds)
HOUSE_EDGE: 3% (u300 basis points)
```

### Data Structures

#### Core Bet Data
```clarity
{
  bettor: principal,           // Address of the bettor
  amount: uint,                // Bet amount in microSTX
  prediction: uint,            // PREDICTION_RISE (u1) or PREDICTION_DROP (u2)
  start-price: uint,           // STX price when bet was placed
  target-price: (optional uint), // Final price for resolution
  start-time: uint,            // When bet was created
  end-time: uint,              // When bet expires
  duration: uint,              // Duration in seconds
  outcome: uint,               // PENDING/WIN/LOSE/DRAW
  resolved: bool,              // Resolution status
  payout: uint                 // Calculated payout amount
}
```

#### User Statistics
```clarity
{
  total-bets: uint,            // Number of bets placed
  total-wagered: uint,         // Total amount wagered
  total-won: uint,             // Total amount won
  total-lost: uint,            // Total amount lost
  win-streak: uint,            // Current winning streak
  best-streak: uint,           // Best winning streak ever
  last-bet-time: uint          // Last betting activity
}
```

## 🔧 Public Functions

### Core Betting Functions

#### `place-bet`
```clarity
(place-bet (amount uint) (prediction uint) (duration uint) (current-price uint))
```
Place a new bet on STX price prediction.

**Parameters:**
- `amount`: Bet amount in microSTX (100,000 - 100,000,000,000)
- `prediction`: PREDICTION_RISE (u1) or PREDICTION_DROP (u2)
- `duration`: Duration in seconds (3,600 - 2,592,000)
- `current-price`: Current STX price in cents

**Returns:** `(response uint uint)` - Bet ID on success

#### `resolve-bet`
```clarity
(resolve-bet (bet-id uint) (final-price uint))
```
Resolve an expired bet with the final price.

**Parameters:**
- `bet-id`: Unique bet identifier
- `final-price`: Final STX price in cents

**Returns:** `(response uint uint)` - Outcome (WIN/LOSE/DRAW)

### Oracle Functions

#### `update-price`
```clarity
(update-price (price uint) (timestamp uint))
```
Update price data (oracle only).

#### `batch-resolve-bet`
```clarity
(batch-resolve-bet (bet-id uint) (final-price uint))
```
Batch resolve for efficiency (oracle only).

### Read-Only Functions

#### `get-bet-info`
```clarity
(get-bet-info (bet-id uint))
```
Get complete bet information.

#### `get-user-stats`
```clarity
(get-user-stats (user principal))
```
Get user's betting statistics.

#### `get-contract-stats`
```clarity
(get-contract-stats)
```
Get overall contract statistics.

#### `get-daily-pool`
```clarity
(get-daily-pool (date uint))
```
Get daily pool information for risk analysis.

### Administrative Functions

#### `set-oracle-address`
```clarity
(set-oracle-address (oracle principal))
```
Set authorized oracle address (owner only).

#### `set-contract-pause`
```clarity
(set-contract-pause (paused bool) (reason (string-ascii 256)))
```
Pause/unpause contract (owner only).

#### `withdraw-house-balance`
```clarity
(withdraw-house-balance (amount uint))
```
Withdraw accumulated house fees (owner only).

## 📋 Usage Examples

### Placing a Bet
```clarity
;; Bet 1 STX that price will rise in next 24 hours
(contract-call? .bet-logic-contract place-bet 
  u1000000        ;; 1 STX in microSTX
  u1              ;; PREDICTION_RISE
  u86400          ;; 24 hours in seconds
  u120            ;; Current price: $1.20
)
```

### Checking Bet Status
```clarity
;; Get bet information
(contract-call? .bet-logic-contract get-bet-info u0)

;; Check if bet can be resolved
(contract-call? .bet-logic-contract can-bet-be-resolved u0)
```

### Viewing Statistics
```clarity
;; Get user stats
(contract-call? .bet-logic-contract get-user-stats 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)

;; Get contract stats
(contract-call? .bet-logic-contract get-contract-stats)
```

## 🔍 Payout Calculation

### Winners
- **Gross Payout**: 2x the bet amount
- **House Edge**: 3% deducted from gross payout
- **Net Payout**: `(bet-amount × 2) - (gross-payout × 0.03)`

### Example
- Bet: 1 STX
- Gross Payout: 2 STX
- House Fee: 0.06 STX
- Net Payout: 1.94 STX

### Losers
- Payout: 0 STX
- Entire bet goes to house balance

### Draws (price change <1%)
- Payout: Original bet amount returned
- No house edge applied

## 🛠️ Development & Testing

### Prerequisites
- [Clarinet](https://github.com/hirosystems/clarinet) CLI tool
- Node.js (for testing framework)

### Setup
```bash
# Clone the repository
git clone <repository-url>
cd stacks-bettors

# Check contract syntax
clarinet check

# Run tests
clarinet test
```

### Project Structure
```
stacks-bettors/
├── contracts/
│   └── bet-logic-contract.clar
├── tests/
│   └── bet-logic-contract_test.ts
├── settings/
│   ├── Devnet.toml
│   ├── Testnet.toml
│   └── Mainnet.toml
├── Clarinet.toml
└── README.md
```

### Available Commands
```bash
# Check contract syntax
clarinet check

# Run tests
clarinet test

# Start local development environment
clarinet integrate

# Deploy to testnet
clarinet deploy --testnet
```

## 🚨 Risk Considerations

### Smart Contract Risks
- **Oracle Dependency**: Relies on external price feeds
- **Time-based Resolution**: Block time variations may affect precision
- **Immutable Logic**: Contract logic cannot be changed after deployment

### Economic Risks
- **House Edge**: 3% fee reduces expected returns
- **Pool Imbalance**: Large bets may be rejected for risk management
- **Market Volatility**: High volatility increases draw probability

### Operational Risks
- **Oracle Failure**: Price updates may be delayed or unavailable
- **Network Congestion**: High fees during network stress
- **Emergency Situations**: Contract may be paused by owner

## 🔐 Security Measures

### Access Control
- **Owner Functions**: Protected by `is-contract-owner` check
- **Oracle Functions**: Protected by `is-authorized-oracle` check
- **Emergency Pause**: Owner can halt all betting operations

### Input Validation
- **Amount Limits**: Enforced min/max betting amounts
- **Duration Limits**: Enforced min/max betting periods
- **Prediction Validation**: Only RISE/DROP predictions accepted
- **Pool Safety**: Risk management prevents extreme concentrations

### Fund Protection
- **Escrow Model**: User funds held in contract until resolution
- **Atomic Operations**: Bet placement and fund transfer are atomic
- **Balance Tracking**: Separate house balance and user funds

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📞 Support

For questions, issues, or contributions:
- Create an issue in the repository
- Contact the development team
- Check the documentation for common solutions

## 🏆 Roadmap

### Phase 1 (Current)
- ✅ Core betting functionality
- ✅ Risk management system
- ✅ Oracle integration
- ✅ Administrative controls

### Phase 2 (Planned)
- 🔄 Multi-asset betting (beyond STX)
- 🔄 Advanced betting strategies
- 🔄 Improved oracle redundancy
- 🔄 Mobile-friendly interface

### Phase 3 (Future)
- 🔄 Cross-chain integration
- 🔄 Governance token
- 🔄 Community-driven features
- 🔄 Advanced analytics dashboard

---

**⚠️ Disclaimer**: This is experimental software. Use at your own risk. Never bet more than you can afford to lose. Past performance does not guarantee future results.
