class CreateGameRounds < ActiveRecord::Migration[7.1]
  def change
    create_table :game_rounds do |t|
      t.references :user, null: false, foreign_key: true
      t.string :client_seed
      t.string :server_seed
      t.string :hashed_seed
      t.integer :nonce
      t.decimal :bet_amount, precision: 18, scale: 8
      t.string :state
      t.string :difficulty
      t.integer :current_row, default: 0
      t.jsonb :game_data
      t.jsonb :history

      t.timestamps
    end
  end
end
