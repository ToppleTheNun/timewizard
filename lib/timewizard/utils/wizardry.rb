module Timewizard
  module Utils
    module Wizardry

      SEMVER_REGEX = /(\d+\.\d+\.\d+)(?:-([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?(?:\+([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?$/

      def self.to_i(stringy)
        stringy.gsub(/\D/, '').to_i || 0
      end

      def self.only_semver(stringy)
        SEMVER_REGEX.match(stringy).to_s
      end

    end
  end
end