class Contact < ApplicationRecord
  belongs_to :user

  enum card_issuer: ["American Express", "Diners Club", "Discover", "JCB", "MasterCard", "Visa", "Maestro", "Dankort"]
end
