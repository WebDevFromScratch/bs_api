require 'rails_helper'

describe Rental do
  describe 'validations:' do
    it 'is invalid without a name' do
      rental = build :rental, name: ''

      expect(rental).not_to be_valid
      expect(rental.errors[:name]).to contain_exactly 'can\'t be blank'
    end

    it 'is invalid with string name, that is already taken' do
      create :rental, name: 'non unique name'
      rental = build :rental, name: 'non unique name'

      expect(rental).not_to be_valid
      expect(rental.errors[:name]).to contain_exactly 'has already been taken'
    end

    it 'is invalid without a daily_rate' do
      rental = build :rental, daily_rate: nil

      expect(rental).not_to be_valid
      expect(rental.errors[:daily_rate]).to include 'can\'t be blank'
    end

    it 'is invalid with a non-number daily_rate' do
      rental = build :rental, daily_rate: 'some rate'

      expect(rental).not_to be_valid
      expect(rental.errors[:daily_rate]).to contain_exactly 'is not a number'
    end

    it 'is invalid with a non-positive daily_rate' do
      rental = build :rental, daily_rate: 0

      expect(rental).not_to be_valid
      expect(rental.errors[:daily_rate]).to contain_exactly 'must be greater than 0'
    end

    it 'is valid with valid attributes' do
      rental = build :rental

      expect(rental).to be_valid
    end
  end
end
