class Contact < ApplicationRecord
  belongs_to :user

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
        contact.save
      end
    end
  end

end
