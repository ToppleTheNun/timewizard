require 'xcodeproj'
require 'find'
require 'versionomy'
require 'timewizard/utils/wizardry'

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

      def find_build_number(lists)
        find_bundle_and_build_version(lists)[1]
      end

      def change_bundle_version(versions, change_to = '-1')
        unless change_to != '-1'
          @new_bundle_version = versions[0]
          versions
        end
        ver = Timewizard::Utils::Wizardry.only_version change_to
        parsed = Versionomy.parse(ver, Versionomy::Format.get('rubygems'))
        versions[0] = parsed.unparse
        @new_bundle_version = versions[0]
        versions
      end

      def change_build_number(versions, change_to = '-1')
        if change_to == '-1'
          ver = Timewizard::Utils::Wizardry.only_version @old_build_number.to_s
          parsed = Versionomy.parse(ver, Versionomy::Format.get('rubygems'))
          parsed = parsed.bump(parsed.parts.length - 1)
          versions[1] = parsed.unparse
          @new_build_number = versions[1]
        else
          ver = Timewizard::Utils::Wizardry.only_version change_to
          parsed = Versionomy.parse ver
          versions[1] = parsed.unparse
          @new_build_number = versions[1]
        end
        versions
      end

      def find_bundle_and_build_version(lists)
        versions = []
        for list in lists do
          list_hash = Xcodeproj::PlistHelper.read list
          versions[0] ||= list_hash["CFBundleShortVersionString"]
          versions[1] ||= list_hash["CFBundleVersion"]

          @old_bundle_version = versions[0]
          @old_build_number = versions[1]
        end
        versions
      end

      def write_plists(versions)
        for list in @plists do
          list_hash = Xcodeproj::PlistHelper.read list
          list_hash["CFBundleShortVersionString"] = versions[0] || list_hash["CFBundleShortVersionString"]
          list_hash["CFBundleVersion"] = versions[0] || list_hash["CFBundleVersion"]
          Xcodeproj::PlistHelper.write(list_hash, list)
        end
      end

    end
  end
end