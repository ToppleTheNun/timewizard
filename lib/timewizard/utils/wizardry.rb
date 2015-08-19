module Timewizard
  module Utils
    module Wizardry

      VERSION_REGEX = /^((\d+\.)?(\d+\.)?(\*|\d+))(?:-([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?(?:\+([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?$/

      def self.to_i(stringy)
        stringy.gsub(/\D/, '').to_i || 0
      end

      def self.only_version(stringy)
        VERSION_REGEX.match(stringy).to_s
      end

    end
  end
end