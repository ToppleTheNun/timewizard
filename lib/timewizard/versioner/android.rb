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
        parts = container.match("android:versionCode=\"(.*)\"")
        version_code = parts[1]

        @old_version = (version_code.to_i)
        @new_version = (version_code.to_i + 1)

        parts
      end

      def change_version_code(parts, change_to = '-1')
        if change_to.to_i >= 0
          parts[0].gsub(parts[1], @changeTo.to_s)
        else
          parts[0].gsub(parts[1], @new_version.to_s)
        end
      end

      def change_manifest(container, change_to = '-1')
        version_codes = find_version_code(container)
        changed_codes = change_version_code(version_codes, change_to)
        container = container.gsub(version_codes[0], changed_codes)
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