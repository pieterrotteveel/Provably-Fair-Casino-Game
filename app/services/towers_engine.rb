class TowersEngine
  ROWS = 9

  def self.generate_mine_path(server_seed, client_seed, nonce, difficulty)
    hash = OpenSSL::HMAC.hexdigest('SHA256', server_seed, "#{client_seed}:#{nonce}")
    
    cols = (difficulty == 'easy') ? 4 : 3
    
    path = []
    9.times do |i|
      chunk = hash[i * 7, 7]
      integer_value = chunk.to_i(16)
      mine_position = integer_value % cols
      path << mine_position
    end
    
    path
  end

  def self.attempt_climb(game_round, column_index)
    unless game_round.active?
      return { status: 'error', message: 'Game is not active' }
    end

    current_row_index = game_round.current_row
    mine_positions = game_round.game_data
    mine_position = mine_positions[current_row_index]

    if column_index == mine_position
      game_round.update!(state: 'busted')
      return { status: 'loss', mine_position: mine_position, message: 'Game Over' }
    else
      next_row = current_row_index + 1
      multiplier = calculate_multiplier(game_round.difficulty, next_row)
      game_round.update!(current_row: next_row)
      
      return { 
        status: 'safe', 
        multiplier: multiplier, 
        next_row: next_row 
      }
    end
  end

  def self.calculate_multiplier(difficulty, row_number)
    base = (difficulty == 'easy' ? 1.3 : 1.5)
    (base ** row_number).round(2)
  end
end
