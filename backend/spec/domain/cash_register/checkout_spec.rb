require 'spec_helper'

RSpec.describe CashRegister::Services::Checkout do
  let(:catalog) do
    {
      'GR1' => CashRegister::Entities::Product.new(code: 'GR1', name: 'Green Tea', price: 3.11)
    }
  end

  let(:rules) do
    [
      CashRegister::Rules::BogoRule.new(product_code: 'GR1')
    ]
  end

  subject(:subject) { described_class.new(pricing_rules: rules, catalog: catalog) }

  it 'returns only 3.11 as BOGO rule' do
    subject.scan('GR1').scan('GR1')
    expect(subject.total).to eq(3.11.to_d)
  end
end
