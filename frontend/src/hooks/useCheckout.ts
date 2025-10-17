import { useQuery } from '@tanstack/react-query'
import { postJson } from '../api/client'
import type { CheckoutResponse } from '../types/checkout'

export function useCheckout(items: string[]) {
  return useQuery<CheckoutResponse>({
    queryKey: ['checkout', items],
    queryFn: () => postJson<CheckoutResponse>('/checkout', { items }, 'Unable to calculate checkout totals'),
    enabled: items.length > 0,
    refetchOnWindowFocus: false,
  })
}
