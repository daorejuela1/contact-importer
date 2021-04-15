class RenameErrorsToReasonFromContactError < ActiveRecord::Migration[6.1]
  def change
    rename_column :contact_errors, :errors, :reason
  end
end
