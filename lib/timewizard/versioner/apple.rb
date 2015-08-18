require 'xcodeproj'
require 'semantic'
require 'find'

module Timewizard
  module Versioner
    class Apple
      attr_accessor :dir
      attr_reader :proj
      attr_reader :plists
      attr_reader :old_bundle_version
      attr_reader :old_build_number
      attr_accessor :new_bundle_version
      attr_accessor :new_build_number

      def initialize(dir)
        @dir = dir
        @proj = nil
        @plists = []
      end

      def find_xcode_project()
        if File.directory?(@dir)
          # check if the directory exists
          unless Dir.exist?(@dir)
            raise "directory passed in does not exist"
          end
          temp_file = nil
          # check if the directory contains a .xcodeproj
          Dir.foreach(@dir.to_s) { |x|
            if x.end_with?(".xcodeproj")
              temp_file = x
            end }
          if temp_file.nil?
            raise "there is no .xcodeproj in the given directory"
          end
          @proj = File.expand_path(temp_file, @dir)
        else
          unless File.exist?(@dir)
            raise "file passed in does not exist"
          end
          unless @dir.end_with?(".xcodeproj")
            raise "file must be a .xcodeproj"
          end
          temp_file = File.absolute_path(@dir)
          @proj = temp_file
        end
      end

      def find_plists()
        if @proj.nil?
          raise "there is no .xcodeproj"
        end
        directory = File.dirname(@proj.to_s)
        unless Dir.exist?(directory)
          raise "proj is not in a directory"
        end
        @plists = Find.find(directory).select { |p| /^.*Info\.plist$/ =~ p }
      end

      def find_bundle_version(lists)
        find_bundle_and_build_version(lists)[0]
      end

      def find_build_version(lists)
        find_bundle_and_build_version(lists)[1]
      end

      def find_bundle_and_build_version(lists)
        versions = []
        for list in lists do
          list_hash = Xcodeproj::PlistHelper.read list
          versions[0] ||= list_hash["CFBundleShortVersionString"]
          versions[1] ||= list_hash["CFBundleVersion"]
        end
      end

    end
  end
end