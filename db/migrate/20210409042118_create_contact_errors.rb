class CreateContactErrors < ActiveRecord::Migration[6.1]
  def change
    create_table :contact_errors do |t|
      t.string :name
      t.string :birthday
      t.string :phone_number
      t.string :address
      t.string :card_number
      t.integer :card_issuer
      t.string :email
      t.text :errors
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
