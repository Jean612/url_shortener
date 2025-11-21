require 'rails_helper'

RSpec.describe Click, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      click = build(:click)
      expect(click).to be_valid
    end

    it 'is not valid without an ip_address' do
      click = build(:click, ip_address: nil)
      expect(click).not_to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to a link' do
      association = described_class.reflect_on_association(:link)
      expect(association.macro).to eq :belongs_to
    end
  end
end
