module Timewizard
  # Contains all utility modules and classes.
  # @since 0.2.4
  module Utils
    # Contains utility functions in a cleverly named module.
    # @author Richard Harrah
    # @since 0.2.4
    module Wizardry

      VERSION_REGEX = /((\d+\.)?(\d+\.)?(\*|\d+))(?:-([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?(?:\+([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?/

      # Returns a substring of the passed-in value that matches {Timewizard::Utils::Wizardry::VERSION_REGEX the version regex}.
      # @param [String] stringy string from which to extract version string
      # @return [String] substring that matches {Timewizard::Utils::Wizardry::VERSION_REGEX the version regex}
      # @raise [ArgumentError] if stringy is null
      def self.only_version(stringy)
        if stringy.nil?
          raise ArgumentError, "stringy cannot be null"
        end
        VERSION_REGEX.match(stringy.to_s).to_s
      end

    end
  end
end