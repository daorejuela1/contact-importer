require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe '#validations' do
    let(:contact) {FactoryBot.build(:contact)}

    it 'has everything ok' do
      expect(contact).to be_valid
    end

    it 'is empty' do
      contact = Contact.new
      expect(contact).not_to be_valid
    end

    it 'has no name' do
      contact.name = nil
      expect(contact).not_to be_valid
    end

    it 'has an empty name' do
      contact.name = ""
      expect(contact).not_to be_valid
    end

    it 'has a name with invalid characters' do
      contact.name = "@daorejuela1"
      expect(contact).not_to be_valid
    end

    it 'has a name with a valid special characters' do
      contact.name = "da-orejuela1"
      expect(contact).to be_valid
    end

    it 'has a name with a valid special characters' do
      contact.name = "da-orejuela1"
      expect(contact).to be_valid
    end

    it 'has no birthday' do
      contact.birthday = nil
      expect(contact).not_to be_valid
    end

    it 'has empty birthday' do
      contact.birthday = ""
      expect(contact).not_to be_valid
    end

    it 'has wrong format birthday' do
      contact.birthday = "2019 30 4"
      expect(contact).not_to be_valid
    end

    it 'has the first (%Y%m%d) format birthday' do
      contact.birthday = "20191204"
      expect(contact).to be_valid
    end

    it 'has the first (%Y%m%d) format birthday without leading zero' do
      contact.birthday = "2019124"
      expect(contact).to be_valid
    end

    it 'has the second (%F) format birthday' do
      contact.birthday = "2019-12-04"
      expect(contact).to be_valid
    end

    it 'has the second (%F) format birthday without leading zero' do
      contact.birthday = "2019-12-4"
      expect(contact).to be_valid
    end

    it 'has as birthday a day greater than today' do
      contact.birthday = "2123-12-24"
      expect(contact).not_to be_valid
    end

    it 'does not has a phone_number' do
      contact.phone_number = nil
      expect(contact).not_to be_valid
    end

    it 'has an empty phone_number' do
      contact.phone_number = ""
      expect(contact).not_to be_valid
    end

    it 'has an invalid phone_number' do
      contact.phone_number = "516849516"
      expect(contact).not_to be_valid
    end

    it 'has the first format phone_number' do
      contact.phone_number = "(+57) 320 432 05 09"
      expect(contact).to be_valid
    end

    it 'has the second format phone_number' do
      contact.phone_number = "(+57) 320-432-05-09"
      expect(contact).to be_valid
    end

    it 'has errors in the second format phone_number' do
      contact.phone_number = "(+57)320-432-05-09"
      expect(contact).not_to be_valid
    end

    it 'has errors the first format phone_number' do
      contact.phone_number = "(+57) 3204320509"
      expect(contact).not_to be_valid
    end

    it 'has no address' do
      contact.address = nil
      expect(contact).not_to be_valid
    end

    it 'has empty address' do
      contact.address = ""
      expect(contact).not_to be_valid
    end

    it 'address has special characters' do
      contact.address = "@#)@()#/bin"
      expect(contact).to be_valid
    end

    it 'address is ok in Colombia' do
      contact.address = "Cll 3 # 93-3"
      expect(contact).to be_valid
    end

    it 'address is ok in Colombia' do
      contact.address = "Cll 3 # 93-3"
      expect(contact).to be_valid
    end

    it 'card_number is empty' do
      contact.address = ""
      expect(contact).not_to be_valid
    end

    it 'card_number no exist' do
      contact.card_number = nil
      expect(contact).not_to be_valid
    end

    it 'card_number is not valid' do
      contact.card_number = "12"
      expect(contact).not_to be_valid
    end

    it 'card_number is valid American Express' do
      contact.card_number = "371449635398431"
      expect(contact).to be_valid
    end

    it 'card_number is valid Discover' do
      contact.card_number = "6011111111111117"
      expect(contact).to be_valid
    end

    it 'card_issuer is American Express' do
      contact.card_number = "371449635398431"
      contact.save
      expect(contact.card_issuer).to be(0)
    end

    it 'card_issuer is Diners Club' do
      contact.card_number = "30569309025904"
      contact.save
      expect(contact.card_issuer).to be(1)
    end

    it 'card_issuer is Discover' do
      contact.card_number = "6011111111111117"
      contact.save
      expect(contact.card_issuer).to be(2)
    end

    it 'card_issuer is JCB' do
      contact.card_number = "3530111333300000"
      contact.save
      expect(contact.card_issuer).to be(3)
    end

    it 'card_issuer is Mastercard' do
      contact.card_number = "5555555555554444"
      contact.save
      expect(contact.card_issuer).to be(4)
    end

    it 'card_issuer is VISA' do
      contact.card_number = "4111111111111111"
      contact.save
      expect(contact.card_issuer).to be(5)
    end

    it 'email does not exist' do
      contact.email = nil
      expect(contact).not_to be_valid
    end

    it 'email is empty' do
      contact.email = ""
      expect(contact).not_to be_valid
    end

    it 'email has no valid format' do
      contact.email = "daorejuela1@outlook"
      expect(contact).not_to be_valid
    end

    it 'email has valid format' do
      contact.email = "daorejuela1@outlook.com"
      expect(contact).to be_valid
    end

    it 'duplicated data but different email' do
      contact2 = FactoryBot.create(:contact, email: "1475@holbertonschool.com")
      expect(contact).to be_valid
    end

    it 'duplicated data same email' do
      contact2 = FactoryBot.create(:contact, email: "1475@holbertonschool.com")
      expect(contact).not_to be_valid
    end

  end

end
