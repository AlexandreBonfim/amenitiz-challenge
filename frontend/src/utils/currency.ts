const currencyFormatter = new Intl.NumberFormat('en-GB', {
  style: 'currency',
  currency: 'EUR',
})

export function formatCurrency(value: number): string {
  return currencyFormatter.format(value)
}
