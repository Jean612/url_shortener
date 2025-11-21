require 'rails_helper'

RSpec.describe Link, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      link = build(:link)
      expect(link).to be_valid
    end

    it 'is not valid without an original_url' do
      link = build(:link, original_url: nil)
      expect(link).not_to be_valid
    end

    it 'is not valid with an invalid original_url format' do
      link = build(:link, original_url: 'invalid-url')
      expect(link).not_to be_valid
    end

    it 'validates uniqueness of slug' do
      create(:link, slug: 'unique')
      link = create(:link)
      link.slug = 'unique'
      expect(link).not_to be_valid
    end
  end

  describe 'associations' do
    it 'has many clicks' do
      association = described_class.reflect_on_association(:clicks)
      expect(association.macro).to eq :has_many
    end
  end

  describe 'callbacks' do
    it 'generates a slug before validation on create' do
      link = build(:link, slug: nil)
      link.valid?
      expect(link.slug).to be_present
    end

    it 'sets default clicks_count to 0' do
      link = create(:link)
      expect(link.clicks_count).to eq 0
    end
  end

  describe '#short_url' do
    it 'returns the full short URL' do
      link = create(:link, slug: 'abc123')
      expect(link.short_url).to include('/abc123')
    end
  end
end
