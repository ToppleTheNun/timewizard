require 'nokogiri'
require 'timewizard/versioner'

module Timewizard
  module Versioner
    # Represents the Worklight implementation of the versioner spec.
    # @author Richard Harrah
    # @since 0.1.0
    class Cordova < Timewizard::Versioner::Base

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

        @file_contents = Nokogiri.XML('')

        if File.exist?(@file)
          @file_contents = File.open(@file, 'r+') { |f| Nokogiri.XML(f) }
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
        File.open(@file, 'w') { |f| @file_contents.write_xml_to(f) }
      end

      def find_build_and_version_numbers
        if @file_contents.nil?
          read_file
        end

        widget = @file_contents.at_css('widget')

        widget_version_num = widget['version']

        parsed_version_num = Versionomy.parse(widget_version_num,
                                              Versionomy::Format.get('rubygems'))

        @bumped_version_number = parsed_version_num.bump(parsed_version_num.parts.length - 1)

        obn = parsed_version_num.unparse
        ovn = parsed_version_num.unparse
        nbn = parsed_version_num.bump(parsed_version_num.parts.length - 1).unparse
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
        # don't actually want to do anything for build numbers for worklight
        nil
      end

      def change_version_numbers
        if @file_contents.nil?
          read_file
        end
        if @new_version_number.nil?
          read_version_numbers
        end
        widget = @file_contents.at_css('widget')

        widget['version'] = @new_version_number.to_s
      end

    end
  end
end