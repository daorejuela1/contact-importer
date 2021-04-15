class Contact < ApplicationRecord
  self.implicit_order_column = "created_at"

  belongs_to :user

  VALID_NAME_REGEX = /\A[a-zA-Z0-9\-\s]+\z/
  VALID_BIRTHDAY_REGEX = /\A(\d{4}\d{2}\d{2}|\d{4}-\d{2}-\d{2})\z/
  VALID_PHONE_NUM_REGEX = /\A\(\+\d{2}\)\s(\d{3}\s\d{3}\s\d{2}\s\d{2}|\d{3}-\d{3}-\d{2}-\d{2})\z/
  VALID_EMAIL_REGEX = /\A[a-zA-Z0-9_.+\-]+@[a-zA-Z0-9\-]+\.[a-zA-Z0-9\-.]+\z/
  VALID_CARD_NUMBER_REGEX = /\A[0-9]+\z/

  validates :name, format: {with: VALID_NAME_REGEX, message: "Invalid name format, only the special character '-' & ' ' are accepted"}
  validate :birthday_date_is_valid
  validates :birthday, format: {with: VALID_BIRTHDAY_REGEX, message: "Invalid birthday format only (%Y%m%d) or (%Y-%m-%d) formats are accepted"}
  validates :phone_number, format: {with: VALID_PHONE_NUM_REGEX, message: "Invalid phone format only (+00) 000 000 00 00 or (+00) 000-000-00-00 formats are accepted"}
  validates :address, presence: true
  validates :email, format: {with: VALID_EMAIL_REGEX, message: "Invalid email format"}, presence: true, uniqueness: {case_sensitive: false, scope: :user_id}
  validates :card_number, format: {with: VALID_CARD_NUMBER_REGEX, message: "Only numbers are valid in credit card"}, presence: true
  validate :get_card_issuer

  enum table_fields: ["Name", "Birthday", "Phone number", "Address", "Card number", "Email"]
  enum card_issuer: ["American Express", "Diners Club", "Discover", "JCB", "MasterCard", "Visa", "Maestro", "Dankort", "Undefined"], _default: "Undefined"

  def self.generate_csv
    CSV.generate(headers: true) do |csv|
      attributes = self.attribute_names.grep_v(/.at|encrypted.|table|user/)
      csv << attributes
      all.each do |record|
        csv << record.attributes.values_at(*attributes)
      end
    end
  end

  private 

  def get_card_issuer
    card_number = self.card_number
    card_number.delete!(' ') if card_number.present?
    detector = CreditCardValidations::Detector.new(card_number)
    if detector.valid?
      if detector.brand_name.match(/China.|Elo|Hipercard|MIR|Rupay|Solo|Switch/)
        errors.add(:card_issuer, "This Issuer hasnt been approved")
      else
        self.card_issuer = detector.brand_name
        self.card_number = card_number[-4..-1]
        self.encrypted_card_number = BCrypt::Password.create(card_number)
      end
    else
      errors.add(:card_number, "Card number is invalid")
    end
  end

  def birthday_date_is_valid
    if birthday.present? && birthday.match(VALID_BIRTHDAY_REGEX) && Date.parse(birthday).after?(Date.today)
      errors.add(:birthday, "We don't accept time travelers")
    end
  end
end
