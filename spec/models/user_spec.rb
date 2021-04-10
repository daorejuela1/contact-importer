require 'spec_helper'

RSpec.describe User, type: :model do

  describe '#validations' do
    let(:user) {FactoryBot.build(:user)}

    it 'does not save if empty' do
      user.email = user.password = user.password_confirmation = nil
      expect(user).not_to be_valid
    end

    it 'user without email' do
      user.email = nil
      expect(user).not_to be_valid
    end

    it 'user without password' do
      user.password = nil
      expect(user).not_to be_valid
    end

    it 'user without password confirmation' do
      user.password_confirmation = ""
      expect(user).not_to be_valid
    end

    it 'user with invalid email' do
      user.email = "test@hotmail"
      expect(user).not_to be_valid
    end

    it 'user with wrong password confirmation' do
      user.password = "admin1234"
      user.password_confirmation="admin12345"
      expect(user).not_to be_valid
    end

    it 'user builded correctly' do
      expect(user).to be_valid
    end

    it 'duplicated email' do
      user2 = FactoryBot.create(:user)
      expect(user).not_to be_valid
    end
  end
end
