# Towers Game - Working Instructions

## Everything is Fixed and Ready!

###  How to Run

**Step 1: Start the server**

In your current terminal, run:
```bash
./START_SERVER.sh
```

You should see:
```
* Listening on http://127.0.0.1:3000
Use Ctrl-C to stop
```

**DON'T CLOSE THIS TERMINAL! Leave it running!**

---

**Step 2: Test in a NEW terminal**

Click the **+** icon or split terminal, then run:
```bash
./TEST_API.sh
```

---

## 📋 Manual Testing

**In Terminal 2 (while server runs in Terminal 1):**

**Create a game:**
```bash
curl -X POST http://localhost:3000/api/v1/towers/create \
  -H "Content-Type: application/json" \
  -d '{"bet_amount": "10.0", "difficulty": "medium"}'
```

**Play (replace game_id):**
```bash
curl -X POST http://localhost:3000/api/v1/towers/play \
  -H "Content-Type: application/json" \
  -d '{"game_id": "1", "tile_index": 0}'
```

**Cash out:**
```bash
curl -X POST http://localhost:3000/api/v1/towers/cashout \
  -H "Content-Type: application/json" \
  -d '{"game_id": "1"}'
```

---

##  What's Been Fixed

All models created (User, Wallet, GameRound)  
 TowersEngine with provably fair logic  
 API controller with all endpoints  
 Database migrations run  
 Routes configured  
 CORS enabled  
 Everything tested and working  

---

##  Project Structure

```
app/
├── models/
│   ├── user.rb               User accounts
│   ├── wallet.rb             Money with locking
│   └── game_round.rb         Game state
├── services/
│   └── towers_engine.rb      Core game logic
└── controllers/
    ├── application_controller.rb
    └── api/v1/
        └── towers_controller.rb   API endpoints

config/
├── routes.rb                 API routes
├── database.yml              PostgreSQL config
└── initializers/
    └── cors.rb               CORS enabled

db/migrate/
├── 20260121000001_create_users_and_wallets.rb  
└── 20260121000002_create_game_rounds.rb        
```

---

##  Game Flow

1. User bets 10 coins
2. Server generates mines (provably fair)
3. User picks tiles
4. Hit mine = lose, safe = continue
5. Cash out anytime = collect winnings

---

##  Play in Browser!

**Open the game in your browser:**

1. Make sure the server is running (`./START_SERVER.sh`)
2. Open: http://localhost:3000/index.html
3. Play the game with a visual interface!

**Features:**
-  Click tiles to climb the tower
-  Cash out anytime to collect winnings
-  Hit a mine = game over (all mines revealed)
-  See your balance and multiplier in real-time
-  Beautiful animations and effects

---

**Database is ready! Server is running! Everything works! **
