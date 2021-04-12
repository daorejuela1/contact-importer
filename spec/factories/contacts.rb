FactoryBot.define do
  factory :contact do
    name { "Smith" }
    birthday { "20191201" }
    phone_number { "(+57) 320-432-05-09" }
    address { "Cll 3 # 30-2" }
    card_number { "371449635398431" }
    card_issuer { 0 }
    email { "daorejuela1@outlook.com" }
    user { User.new(email: "vids@hotmail.es",
                    password: "admin12345",
                    password_confirmation: "admin12345") }
  end
end
