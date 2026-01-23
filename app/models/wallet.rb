class Wallet < ApplicationRecord
  belongs_to :user

  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  def debit!(amount)
    with_lock do
      if balance >= amount
        update!(balance: balance - amount)
      else
        raise "Insufficient funds"
      end
    end
  end

  def credit!(amount)
    with_lock do
      update!(balance: balance + amount)
    end
  end
end
