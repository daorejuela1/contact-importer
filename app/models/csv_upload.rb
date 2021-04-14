class CsvUpload < ApplicationRecord

  include RailsStateMachine::Model

  state_machine do
    state :waiting, initial: true
    state :processing
    state :finished
    state :failed

    event :start_processing do
      transitions from: :waiting, to: :processing
    end

    event :contact_imported do
      transitions from: :processing, to: :finished
    end

    event :nothing_is_good do
      transitions from: :processing, to: :failed
    end

    event :no_contacts_available do
      transitions from: :processing, to: :finished
    end
  end

  def self.state_colors(state)
    colors = {
      waiting: :secondary,
      processing: :primary,
      finished: :success,
      failed: :danger,
    }
    return colors[state.to_sym]
  end

  belongs_to :user

  has_one_attached :csv_file
  validates :csv_file, presence: true
  validate :correct_csv_mime_type

  default_scope {order("created_at DESC")}

  def correct_csv_mime_type
    if csv_file.attached? && !csv_file.content_type.in?(%w(text/csv))
      errors.add(:csv_file, 'Only accept CSV files for the moment')
    end
  end
end
