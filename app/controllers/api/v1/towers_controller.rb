module Api
  module V1
    class TowersController < ApplicationController
      def create
        user = User.first
        unless user
           user = User.create!
           Wallet.create!(user: user, balance: 1000)
        end
        
        wallet = user.wallet
        bet_amount = params[:bet_amount].to_d
        difficulty = params[:difficulty] || 'medium'
        
        if bet_amount <= 0
            render json: { error: "Invalid bet amount" }, status: 400
            return
        end

        begin
          wallet.debit!(bet_amount)
        rescue => e
          render json: { error: "Insufficient funds" }, status: 400
          return
        end

        server_seed = SecureRandom.hex(32)
        client_seed = params[:client_seed] || SecureRandom.hex(12)
        nonce = 1

        mine_path = TowersEngine.generate_mine_path(server_seed, client_seed, nonce, difficulty)

        game = GameRound.create!(
          user: user,
          bet_amount: bet_amount,
          difficulty: difficulty,
          state: 'active',
          client_seed: client_seed,
          server_seed: server_seed,
          hashed_seed: Digest::SHA256.hexdigest(server_seed),
          nonce: nonce,
          game_data: mine_path,
          current_row: 0,
          history: []
        )

        render json: {
          game_id: game.id,
          state: game.state,
          difficulty: game.difficulty,
          current_row: 0,
          hashed_seed: game.hashed_seed,
          available_balance: wallet.balance
        }
      end

      def play
        game = GameRound.find_by(id: params[:game_id])
        unless game
          render json: { error: "Game not found" }, status: 404
          return
        end
        
        tile_index = params[:tile_index].to_i
        result = TowersEngine.attempt_climb(game, tile_index)
        
        if result[:status] == 'loss'
          render json: {
            status: 'game_over',
            mine_hit: result[:mine_position],
            full_path: game.game_data
          }
        elsif result[:status] == 'safe'
          render json: {
            status: 'success',
            multiplier: result[:multiplier],
            next_row: result[:next_row]
          }
        else
           render json: { error: result[:message] }, status: 400
        end
      end

      def cashout
        game = GameRound.find_by(id: params[:game_id])
        unless game && game.active?
             render json: { error: "Cannot cash out" }, status: 400
             return
        end
        
        if game.current_row == 0
             render json: { error: "Must play at least one round" }, status: 400
             return
        end

        multiplier = TowersEngine.calculate_multiplier(game.difficulty, game.current_row)
        payout = game.bet_amount * multiplier
        
        game.update!(state: 'cashed_out')
        game.user.wallet.credit!(payout)
         
        render json: {
            status: 'cashed_out',
            payout: payout,
            multiplier: multiplier,
            balance: game.user.wallet.balance
        }
      end
    end
  end
end
