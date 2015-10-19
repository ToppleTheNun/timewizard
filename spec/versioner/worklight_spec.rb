require 'timewizard/versioner/worklight'

RSpec.describe 'Timewizard::Versioner::Worklight' do

  before(:example) do
    pwd = Dir.pwd.to_s

    FileUtils.rm_rf Dir["#{pwd}/tmp"]
    FileUtils.rm_rf Dir["#{pwd}/pkg"]

    pwd = Dir.pwd.to_s
    FileUtils.cp_r("#{pwd}/resources/.", "#{pwd}/tmp")

    @versioner = Timewizard::Versioner::Worklight.new "#{pwd}/tmp/worklight/application-descriptor.xml"
  end

  context '.new' do
    it 'should raise error if arg is nil' do
      expect { Timewizard::Versioner::Worklight.new nil }.to raise_error("passed in file cannot be nil")
    end

    it 'should not raise error if arg is not nil' do
      expect { Timewizard::Versioner::Worklight.new '' }.not_to raise_error
    end
  end

  context '#file' do
    it 'should be an AndroidManifest.xml' do
      expect(@versioner.file).to eq("#{Dir.pwd.to_s}/tmp/worklight/application-descriptor.xml")
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
    it 'should not raise an error' do
      expect { @versioner.read_build_numbers }.to_not raise_error
    end

    it 'should change instance variables' do
      expect(@versioner.old_build_number).to be_nil
      expect(@versioner.new_build_number).to be_nil
      @versioner.read_build_numbers
      expect(@versioner.old_build_number).to eq('0.0.1')
      expect(@versioner.new_build_number).to eq('0.0.2')
    end
  end

  context '#read_version_numbers' do
    it 'should not raise an error' do
      expect { @versioner.read_version_numbers }.to_not raise_error
    end

    it 'should change instance variables' do
      expect(@versioner.old_version_number).to be_nil
      expect(@versioner.new_version_number).to be_nil
      @versioner.read_version_numbers
      expect(@versioner.old_version_number).to eq('0.0.1')
      expect(@versioner.new_version_number).to eq('0.0.1')
    end
  end

  context '#write_build_numbers' do
    before(:example) do
      @versioner.read_build_numbers
    end

    it 'should not raise an error' do
      expect { @versioner.write_version_numbers }.to_not raise_error
    end

    it 'should not change instance variables' do
      expect(@versioner.old_build_number).to eq('0.0.1')
      expect(@versioner.new_build_number).to eq('0.0.2')
      @versioner.write_build_numbers
      expect(@versioner.old_build_number).to eq('0.0.1')
      expect(@versioner.new_build_number).to eq('0.0.2')
    end

    it 'should change contents of parsed file' do
      expect(@versioner.old_build_number).to eq('0.0.1')
      expect(@versioner.new_build_number).to eq('0.0.2')
      @versioner.write_build_numbers
      @versioner.read_build_numbers
      expect(@versioner.old_build_number).to eq('0.0.2')
      expect(@versioner.new_build_number).to eq('0.0.3')
    end
  end

  context '#write_version_numbers' do
    before(:example) do
      @versioner.read_version_numbers
    end

    it 'should not raise an error' do
      expect { @versioner.write_version_numbers }.to_not raise_error
    end

    it 'should not change instance variables' do
      expect(@versioner.old_version_number).to eq('0.0.1')
      expect(@versioner.new_version_number).to eq('0.0.1')
      @versioner.write_version_numbers
      expect(@versioner.old_version_number).to eq('0.0.1')
      expect(@versioner.new_version_number).to eq('0.0.1')
    end

    it 'should change contents of parsed file' do
      expect(@versioner.old_version_number).to eq('0.0.1')
      expect(@versioner.new_version_number).to eq('0.0.1')
      @versioner.new_version_number = '0.0.2'
      @versioner.write_version_numbers
      @versioner.read_version_numbers
      expect(@versioner.old_version_number).to eq('0.0.2')
      expect(@versioner.new_version_number).to eq('0.0.2')
    end
  end

end