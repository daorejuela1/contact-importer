class RemoveCardNumberFromContactError < ActiveRecord::Migration[6.1]
  def change
    remove_column :contact_errors, :card_number, :string
  end
end
