module Timewizard
  module Versioner
    class Android
      attr_accessor :dir
      attr_reader :manifest
      attr_reader :old_version
      attr_accessor :new_version

      def initialize(dir)
        @dir = dir
        @manifest = nil
        @last_version = 0
      end

      def update(change_to = '-1')
        write_manifest(change_manifest(open_manifest, change_to))
      end

      def find_manifest()
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
        codes = find_version_code_and_number(container)
        codes[0]
      end

      def find_version_number(container)
        codes = find_version_code_and_number(container)
        codes[1]
      end

      def find_version_code_and_number(container)
        parts = container.match("android:versionCode=\"(.*)\"")
        version_code = parts[1]

        @old_version = (version_code.to_i)
        @new_version = (version_code.to_i + 1)

        text = parts[0]
        text_split = text.partition(/\s/)
        codes = [text_split[0], text_split[2]]
      end

      def change_version_code(parts, change_to = '-1')
        text = parts
        version = text.gsub(/\D/, '').to_i.to_s
        if change_to.to_s == '-1'
          text = text.gsub(version, @new_version.to_s)
        else
          @new_version = change_to.to_i
          text = text.gsub(version, change_to.to_s)
        end
      end

      def change_manifest(container, change_to = '-1')
        version_code = find_version_code(container)
        changed_code = change_version_code(version_code, change_to)
        container = container.gsub(version_code, changed_code)
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