class Contact < ApplicationRecord
  self.implicit_order_column = "created_at"

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
  validate :get_card_issuer

  enum table_fields: ["Name", "Birthday", "Phone number", "Address", "Card number", "Email"]
  enum card_issuer: ["American Express", "Diners Club", "Discover", "JCB", "MasterCard", "Visa", "Maestro", "Dankort", "Undefined"], _default: "Undefined"

  def self.import_csv(csv_file, mapping_hash, current_user)
    csv_file.start_processing #Change state of the file
    contact_saved = false
    contact_error_saved = false

    csv_file_name = csv_file.csv_file.filename.to_s
    file_path = ActiveStorage::Blob.service.send(:path_for, csv_file.csv_file.key)
    headers = nil
    CSV.open(File.open(file_path), "r+") do |file|
      headers = file.shift
      file.rewind
      file << headers + ["Contact importer logs"]
      CSV.foreach(file_path, headers: true) do |row|
        contact_dict = Hash.new
        mapping_hash.each do |hash|
          contact_dict[table_fields.key(hash[1].to_i).parameterize.underscore] = row.values_at[hash[0].split("-")[1].to_i]
        end
        contact = current_user.contacts.find_or_initialize_by(contact_dict)
        if contact.save
          # Flag that at least one user was saved
          contact_saved = true
          file << row.values_at + ["OK"]
        else
          contact_error_saved = true
          # Generate error with associated user
          contact_dict.delete("card_number")
          contact_dict[:reason] = contact.errors.full_messages
          file << row.values_at + [contact_dict[:reason].join("-").gsub(",", ".")]
          current_user.contact_errors.find_or_create_by!(contact_dict)
        end
      end
    end
    csv_file.contact_imported if contact_saved
    csv_file.nothing_is_good if !contact_saved && contact_error_saved
    csv_file.no_contacts_available if !contact_saved && !contact_error_saved
  end


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
      self.card_issuer = detector.brand_name
      self.card_number = card_number[-4..-1]
      self.encrypted_card_number = BCrypt::Password.create(card_number)
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
