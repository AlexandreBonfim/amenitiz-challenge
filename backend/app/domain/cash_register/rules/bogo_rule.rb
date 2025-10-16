require_relative "rule"

module CashRegister
  module Rules
    class BogoRule < Rule
      def initialize(product_code:)
        @product_code = product_code
      end

      # returns a discount (BigDecimal >= 0)
      def apply(items)
        matching = items.select { |p| p.code == @product_code }
        return 0.to_d if matching.empty?

        free_units = matching.count / 2
        unit_price = matching.first.price
        (unit_price * free_units).round(2)
      end
    end
  end
end
