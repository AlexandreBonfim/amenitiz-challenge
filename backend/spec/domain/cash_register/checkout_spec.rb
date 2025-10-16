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

  it 'returns 3.11 as BOGO rule' do
    subject.scan('GR1').scan('GR1')

    expect(subject.total).to eq(3.11.to_d)
  end

  it 'returns 16.61 as 3 strawberries have discount' do
    catalog['SR1'] = CashRegister::Entities::Product.new(code: 'SR1', name: 'Strawberries', price: 5.00)
    rules << CashRegister::Rules::BulkPriceRule.new(product_code: 'SR1', threshold: 3, discounted_price: 4.50)

    %w[SR1 SR1 GR1 SR1].each { |c| subject.scan(c) }

    expect(subject.total).to eq(16.61.to_d)
  end
end
