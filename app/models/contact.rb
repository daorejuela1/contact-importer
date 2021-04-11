class Contact < ApplicationRecord
  belongs_to :user

  enum table_fields: ["Name", "Birthday", "Phone number", "Address", "Card number", "Email"]
  enum card_issuer: ["American Express", "Diners Club", "Discover", "JCB", "MasterCard", "Visa", "Maestro", "Dankort"]

	def self.import_csv(file, mapping_hash)
		CSV.foreach(file.path, headers: true) do |row|
			employee_dict = row.to_hash
			employee = Employee.find_or_create_by!(employee_dict)
			employee.update(employee_dict)
		end
	end
end
