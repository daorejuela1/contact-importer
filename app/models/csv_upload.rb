class CsvUpload < ApplicationRecord

  include RailsStateMachine::Model


  state_machine do
    state :waiting, initial: true
    state :processing
    state :finished
    state :failed
    state :empty

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
      transitions from: :processing, to: :empty
    end
  end

  def self.state_colors(state)
    colors = {
      waiting: :secondary,
      processing: :primary,
      finished: :success,
      failed: :danger,
      empty: :info,
    }
    return colors[state.to_sym]
  end

  belongs_to :user

  has_one_attached :csv_file
  validates :csv_file, presence: true
  validate :correct_csv_mime_type

  after_create_commit {broadcast_prepend_to 'csv_uploads'}
  after_update_commit {broadcast_replace_to 'csv_uploads'}
  after_destroy_commit {broadcast_remove_to 'csv_uploads'}

  default_scope {order("created_at DESC")}

  private

  def correct_csv_mime_type
    # correct_csv_mime_type.
    #
    # checks csv_mime_type when being uploaded using a form
    #
    if csv_file.attached? && !csv_file.content_type.in?(%w(text/csv))
      errors.add(:csv_file, 'Only accept CSV files for the moment')
    end
  end
end
