class CsvUpload < ApplicationRecord
  belongs_to :user
  has_one_attached :csv_file
end
