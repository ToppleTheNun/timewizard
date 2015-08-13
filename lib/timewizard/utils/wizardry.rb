module Timewizard
  module Utils
    module Wizardry
      def self.to_i(stringy)
        stringy.gsub(/\D/, '').to_i || 0
      end
    end
  end
end