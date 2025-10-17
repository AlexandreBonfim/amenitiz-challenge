export type CheckoutResponse = {
  items: string[]
  subtotal: string
  discount: string
  total: string
}

export type CartSummary = {
  subtotal: string
  discount: string
  total: string
}
