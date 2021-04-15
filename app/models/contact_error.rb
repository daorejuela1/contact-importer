class ContactError < ApplicationRecord
  default_scope {order("created_at DESC")}
  belongs_to :user

  validates :reason, presence: true

end
