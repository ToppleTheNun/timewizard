require 'timewizard/utils/wizardry'

RSpec.describe 'Timewizard::Utils::Wizardry' do
  context '.only_version' do
    it 'should raise an error when arg is nil' do
      expect { Timewizard::Utils::Wizardry.only_version nil }.to raise_error('stringy cannot be null')
    end

    it 'should return the same value when given a proper version number' do
      base = '0.0.1'

      expected = '0.0.1'
      actual = Timewizard::Utils::Wizardry.only_version base

      expect(actual).to eq(expected)
    end

    it 'should return a version number when given a text string containing a version number' do
      base = 'this is version 0.0.1'

      expected = '0.0.1'
      actual = Timewizard::Utils::Wizardry.only_version base

      expect(actual).to eq(expected)
    end

    it 'should return a version number when version number is in the middle of the string' do
      base = 'this, 0.0.1, is the version being test'

      expected = '0.0.1'
      actual = Timewizard::Utils::Wizardry.only_version base

      expect(actual).to eq(expected)
    end
  end
end