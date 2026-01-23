class CreateUsersAndWallets < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.timestamps
    end

    create_table :wallets do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :balance, precision: 18, scale: 8, default: 0

      t.timestamps
    end
  end
end
