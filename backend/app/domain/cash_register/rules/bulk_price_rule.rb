require_relative "rule"

module CashRegister
  module Rules
    # If you buy threshold-or-more of a product, every unit of that product is priced at discounted_price
    class BulkPriceRule < Rule
      def initialize(product_code:, threshold:, discounted_price:)
        @product_code      = product_code
        @threshold         = threshold
        @discounted_price  = BigDecimal(discounted_price.to_s)
      end

      def apply(items)
        matching = items.select { |p| p.code == @product_code }

        return 0.to_d if matching.count < @threshold

        unit_price = matching.first.price
        discount_per_unit = (unit_price - @discounted_price)
        (discount_per_unit * matching.count).round(2)
      end
    end
  end
end
