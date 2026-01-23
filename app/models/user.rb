class User < ApplicationRecord
  has_many :game_rounds
  has_one :wallet
end
