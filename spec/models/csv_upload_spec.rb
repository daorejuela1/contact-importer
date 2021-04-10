require 'rails_helper'

RSpec.describe CsvUpload, type: :model do
  describe '#Validations' do
    let(:csv_upload) {FactoryBot.build(:csv_upload)}
    it 'has no state' do
      csv_upload.state = nil
      expect(csv_upload).not_to be_valid
    end

    it 'has no user' do
      csv_upload.user = nil
      expect(csv_upload).not_to be_valid
    end

  end
end
