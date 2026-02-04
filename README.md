# Towers - Provably Fair Casino Game

A **Tower Climb** style provably fair casino mini-game built with Ruby on Rails 8 and a vanilla JavaScript frontend.

![Ruby](https://img.shields.io/badge/Ruby-3.4.1-red)
![Rails](https://img.shields.io/badge/Rails-8.1.2-red)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16+-blue)
![License](https://img.shields.io/badge/License-MIT-green)

---

## Disclaimer

> **IMPORTANT: This project is for educational and demonstration purposes only.**
>
> - This software is **NOT** intended for real-money gambling operations
> - Operating online gambling services requires proper licensing in most jurisdictions
> - The authors are not responsible for any misuse of this software
> - Users must comply with all applicable laws in their jurisdiction
> - Gambling can be addictive — if you or someone you know has a gambling problem, please seek help

---

## Game Overview

**Towers** is a risk-reward climbing game where players:

1. Place a bet and choose a difficulty level
2. Attempt to climb a 9-row tower
3. Each row has multiple tiles - one contains a hidden mine
4. Successfully avoiding the mine increases your multiplier
5. Hit a mine and lose your bet, or cash out anytime to secure winnings

### Difficulty Levels

| Difficulty | Tiles per Row | Multiplier/Row | Max Payout (9 rows) |
|------------|---------------|----------------|---------------------|
| Easy       | 4             | 1.3×           | ~10.6× bet          |
| Medium     | 3             | 1.5×           | ~38.4× bet          |

---

## Provably Fair System

This game implements a cryptographic provably fair system:

1. **Before the game**: Server generates a random seed and shows you its SHA-256 hash
2. **During the game**: You can provide your own client seed
3. **After the game**: Server reveals the original seed — you can verify it hashes to the value shown before

### Verification

The mine path is generated using:
```
HMAC-SHA256(server_seed, client_seed:nonce)
```

You can verify any game result by:
1. Confirming `SHA256(server_seed) === hashed_seed_shown_before_game`
2. Recalculating the mine path using the revealed seeds

---

## Technical Architecture

### Stack

- **Backend**: Ruby 3.4.1, Rails 8.1.2 (API mode)
- **Database**: PostgreSQL
- **Server**: Puma
- **Frontend**: Vanilla HTML/CSS/JavaScript

### Project Structure

```
├── app/
│   ├── controllers/api/v1/
│   │   └── towers_controller.rb    # API endpoints
│   ├── models/
│   │   ├── game_round.rb           # Game state & history
│   │   ├── user.rb                 # Player accounts
│   │   └── wallet.rb               # Balance management
│   └── services/
│       └── towers_engine.rb        # Core game logic
├── public/
│   └── index.html                  # Game UI
└── config/
    └── routes.rb                   # API routing
```

### API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v1/towers/create` | Start a new game |
| POST | `/api/v1/towers/play` | Pick a tile |
| POST | `/api/v1/towers/cashout` | Cash out winnings |

---

## Getting Started

### Prerequisites

- Ruby 3.4.1+
- PostgreSQL 14+
- Bundler

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/towers-game.git
   cd towers-game
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Setup database**
   ```bash
   bin/rails db:create
   bin/rails db:migrate
   ```

4. **Start the server**
   ```bash
   bin/rails server
   ```

5. **Open your browser**
   ```
   http://localhost:3000
   ```

### Environment Variables (Production)

```bash
RAILS_ENV=production
TOWERS_GAME_DATABASE_PASSWORD=your_secure_password
SECRET_KEY_BASE=your_secret_key_base
```

---

## Testing the API

### Create a new game
```bash
curl -X POST http://localhost:3000/api/v1/towers/create \
  -H "Content-Type: application/json" \
  -d '{"bet_amount": 10, "difficulty": "medium"}'
```

### Play a turn
```bash
curl -X POST http://localhost:3000/api/v1/towers/play \
  -H "Content-Type: application/json" \
  -d '{"game_id": 1, "tile_index": 0}'
```

### Cash out
```bash
curl -X POST http://localhost:3000/api/v1/towers/cashout \
  -H "Content-Type: application/json" \
  -d '{"game_id": 1}'
```

---

## Database Schema

### game_rounds
| Column | Type | Description |
|--------|------|-------------|
| bet_amount | decimal | Wagered amount |
| difficulty | string | easy/medium/hard |
| state | string | active/cashed_out/busted |
| current_row | integer | Current position (0-9) |
| server_seed | string | Secret seed (revealed after game) |
| client_seed | string | Player-provided seed |
| hashed_seed | string | SHA256 of server_seed |
| game_data | jsonb | Mine positions array |

### wallets
| Column | Type | Description |
|--------|------|-------------|
| balance | decimal(18,8) | Current balance |
| user_id | bigint | Associated user |

---

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Acknowledgments

- Inspired by tower/mine games on various crypto casino platforms
- Built as a demonstration of provably fair gaming concepts
- Thanks to the Ruby on Rails community

---

**Remember: Gamble responsibly. This is for educational purposes only.**
