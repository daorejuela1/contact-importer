class RemoveEncryptedCardNumberIvFromContacts < ActiveRecord::Migration[6.1]
  def change
    remove_column :contacts, :encrypted_card_number_iv, :string
  end
end
