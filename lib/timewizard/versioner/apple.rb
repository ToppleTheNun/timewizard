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

      #
      # Public functions
      #

      public

      def initialize(dir)
        @dir = dir
        @proj = nil
        @plists = []
      end

      def find_xcode_project()
        if @dir.nil?
          raise "directory cannot be nil"
        end
        if @dir.end_with? ".xcodeproj"
          @proj = File.absolute_path(@dir)
        else
          Find.find(@dir) do |path|
            unless path.to_s.end_with? ".xcodeproj"
              next
            end
            @proj = path
          end
        end
        @proj
      end

      def find_plists()
        if @proj.nil?
          raise "there is no .xcodeproj"
        end
        directory = File.dirname(@proj.to_s)
        unless Dir.exist?(directory)
          raise "proj is not in a directory"
        end
        @plists = []
        Find.find(directory) do |p|
          if /^.*Info\.plist$/ =~ p
            @plists << p
          end
        end
        @plists
      end

      def find_bundle_version(lists)
        find_bundle_and_build_version(lists)[0]
      end

      def find_build_version(lists)
        find_bundle_and_build_version(lists)[1]
      end

      #
      # Private functions
      #

      private

      def find_bundle_and_build_version(lists)
        versions = []
        for list in lists do
          list_hash = Xcodeproj::PlistHelper.read list
          versions[0] ||= list_hash["CFBundleShortVersionString"]
          versions[1] ||= list_hash["CFBundleVersion"]
        end
        versions
      end

    end
  end
end