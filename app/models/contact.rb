class Contact < ApplicationRecord
  belongs_to :user
  validates :card_number, presence: true, credit_card_number: true
  attr_encrypted :card_number, key: "This is a key that is 256 bits!!"
  before_save :set_card_issuer

  enum table_fields: ["Name", "Birthday", "Phone number", "Address", "Card number", "Email"]
  enum card_issuer: ["American Express", "Diners Club", "Discover", "JCB", "MasterCard", "Visa", "Maestro", "Dankort"]

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

  def set_card_issuer
    detector = CreditCardValidations::Detector.new(card_number)
    self.card_issuer = detector.brand_name
  end
end
