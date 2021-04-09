FactoryBot.define do
  factory :contact_error do
    name { "daorejuela1" }
    birthday { "1995-10-24" }
    phone_number { "(+57) 320 432 05 09" }
    address { "Cll 3 # 34-2" }
    card_number { "30569309025904" }
    card_issuer { 1 }
    email { "daorejuela1@outlook.com" }
    errors { "No errors" }
    user { User.new(email: "vids@hotmail.es",
                    password: "admin12345",
                    password_confirmation: "admin12345") }
  end
end
