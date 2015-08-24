require 'timewizard/versioner'

RSpec.describe 'Timewizard::Versioner::Base' do

  context '.new' do
    it 'should raise error if arg is nil' do
      expect { Timewizard::Versioner::Base.new nil }.to raise_error("passed in file cannot be nil")
    end

    it 'should not raise error if arg is not nil' do
      expect { Timewizard::Versioner::Base.new '' }.not_to raise_error
    end
  end

  before(:context) do
    @versioner = Timewizard::Versioner::Base.new ''
  end

  context '#file' do
    it 'should be empty string' do
      expect(@versioner.file).to eq('')
    end
  end

  context '#old_build_number' do
    it 'should be nil' do
      expect(@versioner.old_build_number).to be_nil
    end
  end

  context '#old_version_number' do
    it 'should be nil' do
      expect(@versioner.old_version_number).to be_nil
    end
  end

  context '#new_build_number' do
    it 'should be nil' do
      expect(@versioner.new_build_number).to be_nil
    end
  end

  context '#new_build_number=' do
    it 'should change instance variable' do
      @versioner.new_build_number = '1'
      expect(@versioner.new_build_number).not_to be_nil
      @versioner.new_build_number = nil
      expect(@versioner.new_build_number).to be_nil
    end
  end

  context '#new_version_number' do
    it 'should be nil' do
      expect(@versioner.new_version_number).to be_nil
    end
  end

  context '#new_version_number=' do
    it 'should change instance variable' do
      @versioner.new_version_number = '1'
      expect(@versioner.new_version_number).not_to be_nil
      @versioner.new_version_number = nil
      expect(@versioner.new_version_number).to be_nil
    end
  end

  context '#read_build_numbers' do
    it 'should not be implemented' do
      expect { @versioner.read_build_numbers }.to raise_error(NotImplementedError)
    end
  end

  context '#read_version_numbers' do
    it 'should not be implemented' do
      expect { @versioner.read_version_numbers }.to raise_error(NotImplementedError)
    end
  end

  context '#write_build_numbers' do
    it 'should not be implemented' do
      expect { @versioner.write_build_numbers }.to raise_error(NotImplementedError)
    end
  end

  context '#write_version_numbers' do
    it 'should not be implemented' do
      expect { @versioner.write_version_numbers }.to raise_error(NotImplementedError)
    end
  end
  
end