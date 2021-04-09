FactoryBot.define do
  factory :user do
    email { "test@hotmail.es" }
    password  { "admin12345" }
    password_confirmation  { "admin12345" }
  end
end
