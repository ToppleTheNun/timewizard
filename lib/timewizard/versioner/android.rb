require 'timewizard/utils/wizardry'

module Timewizard
  module Versioner
    class Android
      attr_accessor :dir
      attr_reader :manifest
      attr_reader :old_version_code
      attr_reader :old_version_name
      attr_accessor :new_version_code
      attr_accessor :new_version_name

      def initialize(dir)
        @dir = dir
        @manifest = nil
      end

      def update(change_to = '-1')
        write_manifest(change_manifest(open_manifest, change_to))
      end

      def find_manifest()
        if File.directory?(@dir)
          # check if the directory exists
          unless Dir.exist?(@dir)
            raise "directory passed in does not exist"
          end
          temp_file = nil
          # check if the directory contains an AndroidManifest.xml
          Dir.foreach(@dir.to_s) { |x|
            if x == "AndroidManifest.xml"
              temp_file = x
            end }
          if temp_file.nil?
            raise "there is no AndroidManifest.xml in the given directory"
          end
          @manifest = File.expand_path(temp_file, @dir)
        else
          unless File.exist?(@dir)
            raise "file passed in does not exist"
          end
          temp_file = File.absolute_path(@dir)
          @manifest = temp_file
        end
      end

      def open_manifest()
        if @manifest.nil?
          find_manifest
        end

        file_str = ''

        if File.exist?(@manifest)
          file_str = File.open(@manifest, 'r+') { |file| file.read }
        end

        file_str
      end

      def find_version_code(container)
        codes = find_version_code_and_name(container)
        codes[0]
      end

      def find_version_name(container)
        codes = find_version_code_and_name(container)
        codes[1]
      end

      def find_version_code_and_name(container)
        parts = container.match("android:versionCode=\"(.*)\"")

        text = parts[0]
        text_split = text.partition /\s+/

        @old_version_code = Timewizard::Utils::Wizardry.to_i text_split[0]
        @new_version_code = (@old_version_code + 1)

        @old_version_name = Timewizard::Utils::Wizardry.only_semver text_split[2]
        @new_version_name = @old_version_name

        codes = [text_split[0], text_split[2]]
      end

      def change_version_code(parts, change_to = '-1')
        text = parts
        version = Timewizard::Utils::Wizardry.to_i(text).to_s
        if change_to.to_s == '-1'
          text = text.gsub(version, @new_version_code.to_s)
        else
          @new_version_code = change_to.to_i
          text = text.gsub(version, @new_version_code.to_s)
        end
      end

      def change_version_name(parts, change_to = '-1')
        text = parts
        version = Timewizard::Utils::Wizardry.only_semver text
        if change_to.to_s == '-1'
          text = text.gsub(version, @new_version_name.to_s)
        else
          @new_version_name = Timewizard::Utils::Wizardry.only_semver change_to
          text = text.gsub(version, @new_version_name.to_s)
        end
      end

      def change_manifest(container, version_code_change = '-1', version_name_change = '-1')
        version_code = find_version_code(container)
        changed_code = change_version_code(version_code, version_code_change)
        version_name = find_version_name(container)
        changed_name = change_version_name(version_name, version_name_change)
        container = container.gsub(version_code, changed_code).gsub(version_name, changed_name)
      end

      def write_manifest(container)
        if @manifest.nil?
          find_manifest
        end
        File.open(@manifest, 'w') { |file| file.write(container) }
      end
    end
  end
end