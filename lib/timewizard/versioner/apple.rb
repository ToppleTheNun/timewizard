require 'cfpropertylist'
require 'timewizard/versioner'

module Timewizard
  module Versioner
    # Represents the Apple implementation of the versioner spec.
    # @author Richard Harrah
    # @since 0.2.3
    class Apple < Timewizard::Versioner::Base

      #
      # Public functions (inherited from parent)
      #
      public

      def initialize(path_to_file)
        super path_to_file
        @file_contents = CFPropertyList::List.new
      end

      #
      # Private functions (implementation specific)
      #
      private

      def read_file
        if @file.nil?
          raise 'file is nil and cannot be read'
        end

        @file_contents = CFPropertyList::List.new

        if File.exist?(@file)
          @file_contents.load(@file)
        end

        @file_contents
      end

      def write_file
        if @file.nil?
          raise 'file is nil and cannot be written'
        end
        if @file_contents.nil?
          raise 'file_contents is nil and cannot be written'
        end
        @file_contents.formatted = true
        @file_contents.save(@file)
      end

      def find_build_and_version_numbers
        if @file_contents.nil?
          read_file
        end

        data = CFPropertyList.native_types(@file_contents.value)

        build_num = Timewizard::Utils::Wizardry.only_version(data['CFBundleVersion'])
        version_num = Timewizard::Utils::Wizardry.only_version(data['CFBundleShortVersionString'])

        parsed_build_num = Versionomy.parse(build_num, Versionomy::Format.get('rubygems'))
        parsed_version_num = Versionomy.parse(version_num, Versionomy::Format.get('rubygems'))

        @bumped_build_number = parsed_build_num.bump(parsed_build_num.parts.length - 1)
        @bumped_version_number = parsed_version_num.bump(parsed_version_num.parts.length - 1)

        obn = parsed_build_num.unparse
        ovn = parsed_version_num.unparse
        nbn = parsed_build_num.bump(parsed_build_num.parts.length - 1).unparse
        nvn = ovn

        [obn, ovn, nbn, nvn]
      end

      def change_build_numbers
        if @file_contents.nil?
          read_file
        end
        if @new_build_number.nil?
          read_build_numbers
        end
        data = CFPropertyList.native_types(@file_contents.value)
        data['CFBundleVersion'] = @new_build_number.to_s

        @file_contents.value = CFPropertyList.guess(data)
      end

      def change_version_numbers
        if @file_contents.nil?
          read_file
        end
        if @new_version_number.nil?
          read_build_numbers
        end
        data = CFPropertyList.native_types(@file_contents.value)
        data['CFBundleShortVersionString'] = @new_version_number.to_s

        @file_contents.value = CFPropertyList.guess(data)
      end

    end
  end
end
