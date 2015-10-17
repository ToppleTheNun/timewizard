require 'timewizard/versioner'

module Timewizard
  module Versioner
    # Represents the Android implementation of the versioner spec.
    # @author Richard Harrah
    # @since 0.1.0
    class Android < Timewizard::Versioner::Base

      #
      # Public functions (inherited from parent)
      #
      public

      def initialize(path_to_file)
        super path_to_file
        @file_contents = ''
      end

      #
      # Private functions (implementation specific)
      #
      private

      SPACE_REGEX = /\s+/

      def read_file
        if @file.nil?
          raise 'file is nil and cannot be read'
        end

        @file_contents = ''

        if File.exist?(@file)
          @file_contents = File.open(@file, 'r+') { |f| f.read }
        end

        @file_contents
      end

      def write_file
        if @file.nil?
          raise 'file is nil and cannot be written'
        end
        if @file_contents.nil?
          raise 'file_contents is null and cannot be written'
        end
        File.open(@file, 'w') { |file| file.write(@file_contents) }
      end

      def find_build_and_version_numbers
        if @file_contents.nil?
          read_file
        end
        matched = @file_contents.match "android:versionCode=\"(.*)\""

        first_match = matched[0]
        split_match = first_match.partition(SPACE_REGEX)

        build_num = Timewizard::Utils::Wizardry.only_version split_match[0]
        version_num = Timewizard::Utils::Wizardry.only_version split_match[2]

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
        @file_contents.gsub!(@old_build_number.to_s, @new_build_number.to_s)
      end

      def change_version_numbers
        if @file_contents.nil?
          read_file
        end
        if @new_version_number.nil?
          read_version_numbers
        end
        @file_contents.gsub!(@old_version_number.to_s, @new_version_number.to_s)
      end

    end
  end
end