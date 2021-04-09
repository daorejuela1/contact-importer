require 'rails_helper'

RSpec.describe ContactError, type: :model do
  describe '#validations' do
    let(:contact_error) {FactoryBot.build(:contact_error)}

  it 'has no error message' do
    contact_error.errors = nil
    expect(contact_error).not_to be_valid
  end

  it 'has an empty error message' do
    contact_error.errors = ""
    expect(contact_error).not_to be_valid
  end

  it 'has an error message' do
    expect(contact_error).to be_valid
  end

  it 'duplicated data' do
    contact_error2 = FactoryBot.create(:contact_error)
    expect(contact_error).to be_valid
  end

  end
end
