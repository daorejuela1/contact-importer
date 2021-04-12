class Contact < ApplicationRecord

  belongs_to :user

  VALID_NAME_REGEX = /\A[a-zA-Z0-9\-]+\z/
  VALID_BIRTHDAY_REGEX = /\A(\d{4}\d{2}\d{2}|\d{4}-\d{2}-\d{2})\z/
  VALID_PHONE_NUM_REGEX = /\A\(\+\d{2}\)\s(\d{3}\s\d{3}\s\d{2}\s\d{2}|\d{3}-\d{3}-\d{2}-\d{2})\z/
  VALID_EMAIL_REGEX = /\A[a-zA-Z0-9_.+\-]+@[a-zA-Z0-9\-]+\.[a-zA-Z0-9\-.]+\z/

  validates :name, format: {with: VALID_NAME_REGEX, message: "Invalid name format, only the special character '-' is accepted"}
  validate :birthday_date_is_valid
  validates :birthday, format: {with: VALID_BIRTHDAY_REGEX, message: "Invalid birthday format only (%Y%m%d) or (%Y-%m-%d) formats are accepted"}
  validates :phone_number, format: {with: VALID_PHONE_NUM_REGEX, message: "Invalid phone format only (+00) 000 000 00 00 or (+00) 000-000-00-00 formats are accepted"}
  validates :address, presence: true
  validates :email, format: {with: VALID_EMAIL_REGEX, message: "Invalid email format"}, presence: true, uniqueness: {case_sensitive: false, scope: :user_id}
  validates :card_number, presence: true, credit_card_number: true
  attr_encrypted :card_number, key: "This is a key that is 256 bits!!"
  before_save :set_card_issuer

  enum table_fields: ["Name", "Birthday", "Phone number", "Address", "Card number", "Email"]
  enum card_issuer: ["American Express", "Diners Club", "Discover", "JCB", "MasterCard", "Visa", "Maestro", "Dankort", "Undefined"], _default: "Undefined"

  def self.import_csv(csv_file, mapping_hash, current_user)
    csv_file.csv_file.open do |file|
      CSV.foreach(file.path, headers: true) do |row|
        contact_dict = Hash.new
        mapping_hash.each do |hash|
          contact_dict[table_fields.key(hash[1].to_i).parameterize.underscore] = row.values_at[hash[0].split("-")[1].to_i]
        end
        contact = current_user.contacts.find_or_initialize_by(contact_dict)
        if contact.save
          p "Saved!!"
        else
          p contact.errors.full_messages
        end
      end
    end
  end

  private 

  def set_card_issuer
    detector = CreditCardValidations::Detector.new(card_number)
    self.card_issuer = detector.brand_name
  end

  def birthday_date_is_valid
    if birthday.present? && birthday.match(VALID_BIRTHDAY_REGEX) && Date.parse(birthday).after?(Date.today)
      errors.add(:birthday, "We don't accept time travelers")
    end
  end
end
