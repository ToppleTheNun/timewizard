require 'versionomy'
require 'timewizard/utils/wizardry'

module Timewizard
  # Contains the various OS implementations of the RubyGem version spec.
  # @author Richard Harrah
  # @since 0.1.0
  module Versioner
    # Represents the most basic of versioners. Raises errors if attempted to be used.
    # @abstract
    # @author Richard Harrah
    # @since 0.2.4
    class Base

      public

      # file to parse
      # @return [String] file that is going to be parsed
      attr_reader :file

      # build number held by parsed file
      # @return [String] build number currently contained in the parsed file
      attr_reader :old_build_number

      # version number held by parsed file
      # @return [String] version number currently contained in the parsed file
      attr_reader :old_version_number

      # bumped build number from parsed file
      # @return [String] bumped build number
      attr_reader :bumped_build_number

      # bumped version number from parsed file
      # @return [String] bumped version number
      attr_reader :bumped_version_number

      # build number to write to parsed file
      # @return [String] build number to write to the parsed file
      attr_accessor :new_build_number

      # version number to write to parsed file
      # @return [String] version number to write to the parsed file
      attr_accessor :new_version_number

      # Creates a new Versioner instance.
      # @param [String] path_to_file path to file that contains version information
      # @return [self] new Versioner instance
      def initialize(path_to_file)
        if path_to_file.nil?
          raise "passed in file cannot be nil"
        end
        @file = path_to_file
        @old_build_number = nil
        @old_version_number = nil
        @bumped_build_number = nil
        @bumped_version_number = nil
        @new_build_number = nil
        @new_version_number = nil
      end

      # Reads the build numbers from {Timewizard::Versioner::Base.file}.
      # @return [self] mutated versioner instance
      def read_build_numbers
        read_file
        find_build_numbers
        self
      end

      # Reads the version numbers from {Timewizard::Versioner::Base.file}.
      # @return [self] mutated versioner instance
      def read_version_numbers
        read_file
        find_version_numbers
        self
      end

      # Writes the build numbers to {Timewizard::Versioner::Base.file}.
      # @return [self] mutated versioner instance
      def write_build_numbers
        change_build_numbers
        write_file
        self
      end

      # Writes the version numbers to {Timewizard::Versioner::Base.file}.
      # @return [self] mutated versioner instance
      def write_version_numbers
        change_version_numbers
        write_file
        self
      end

      private

      def read_file
        raise NotImplementedError
      end

      def write_file
        raise NotImplementedError
      end

      def find_build_numbers
        bn = find_build_and_version_numbers
        @old_build_number = bn[0]
        @new_build_number = bn[2]
        [@old_build_number, @new_build_number]
      end

      def find_version_numbers
        vn = find_build_and_version_numbers
        @old_version_number = vn[1]
        @new_version_number = vn[3]
        [@old_version_number, @new_version_number]
      end

      def find_build_and_version_numbers
        raise NotImplementedError
      end

      def change_build_numbers
        raise NotImplementedError
      end

      def change_version_numbers
        raise NotImplementedError
      end

    end

    autoload :Android, 'timewizard/versioner/android'
    autoload :Apple, 'timewizard/versioner/apple'
    autoload :Worklight, 'timewizard/versioner/worklight'
  end
end