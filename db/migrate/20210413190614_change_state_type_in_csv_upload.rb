class ChangeStateTypeInCsvUpload < ActiveRecord::Migration[6.1]
  def change
    change_column:csv_uploads, :state, :string
  end
end
