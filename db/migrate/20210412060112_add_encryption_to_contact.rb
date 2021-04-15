class AddEncryptionToContact < ActiveRecord::Migration[6.1]
  def change
    add_column :contacts, :encrypted_card_number, :string
    add_column :contacts, :encrypted_card_number_iv, :string
    add_index :contacts, :encrypted_card_number_iv, unique: true
  end
end
