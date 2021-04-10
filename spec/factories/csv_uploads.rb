FactoryBot.define do
  factory :csv_upload do
    state { 1 }
    user { FactoryBot.create(:user) }
  end
end
