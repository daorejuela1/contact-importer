class CsvUpload < ApplicationRecord
  belongs_to :user
  has_one_attached :csv_file
  validates :csv_file, presence: true
  validate :correct_csv_mime_type


  def correct_csv_mime_type
    if csv_file.attached? && !csv_file.content_type.in?(%w(text/csv))
      errors.add(:csv_file, 'Only accept CSV files for the moment')
    end
  end
end
