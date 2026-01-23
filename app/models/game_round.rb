class GameRound < ApplicationRecord
  belongs_to :user

  validates :bet_amount, presence: true, numericality: { greater_than: 0 }
  validates :difficulty, inclusion: { in: %w[easy medium hard] }
  validates :state, inclusion: { in: %w[created active cashed_out busted] }

  def active?
    state == 'active'
  end

  def game_over?
    %w[cashed_out busted].include?(state)
  end
end
