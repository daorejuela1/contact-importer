class CreateCsvUploads < ActiveRecord::Migration[6.1]
  def change
    create_table :csv_uploads do |t|
      t.integer :state
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
