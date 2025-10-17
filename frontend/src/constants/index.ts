import type { CatalogItem } from "../types/catalog";

export const CATALOG: CatalogItem[] = [
    {
      code: 'GR1',
      name: 'Green Tea',
      price: 3.11,
      description: 'Buy-one-get-one-free',
    },
    {
      code: 'SR1',
      name: 'Strawberries',
      price: 5.0,
      description: 'Bulk price drops to €4.50 when buying 3+',
    },
    {
      code: 'CF1',
      name: 'Coffee',
      price: 11.23,
      description: 'All coffees cost 2/3 when 3+ in cart',
    },
  ] as const
  