module CashRegister
  module Rules
    class Rule
      def apply(_items)
        raise NotImplementedError
      end
    end
  end
end
