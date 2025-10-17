import type { CatalogItem } from "../types/catalog";
import type { CartSummary } from "../types/checkout";
import { formatCurrency } from "../utils/currency";

export type GroupedCartItem = {
  item: CatalogItem;
  quantity: number;
};

type BasketProps = {
  items: GroupedCartItem[];
  totals: CartSummary;
  hasItems: boolean;
  isUpdating: boolean;
  errorMessage?: string;
  onAdd: (code: string) => void;
  onRemove: (code: string) => void;
  onClear: () => void;
};

export function Basket({
  items,
  totals,
  hasItems,
  isUpdating,
  errorMessage,
  onAdd,
  onRemove,
  onClear,
}: BasketProps) {
  return (
    <section className="space-y-6 rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
      <div className="flex items-center justify-between gap-4">
        <h2 className="text-xl font-semibold text-slate-900">Basket</h2>
        <button
          type="button"
          onClick={onClear}
          disabled={!hasItems}
          className="rounded-full border border-slate-200 px-4 py-2 text-sm font-medium text-slate-600 transition hover:border-slate-300 hover:bg-slate-50 disabled:cursor-not-allowed disabled:opacity-50"
        >
          Clear
        </button>
      </div>

      {!hasItems ? (
        <p className="rounded-xl border border-dashed border-slate-200 bg-slate-50 px-4 py-6 text-center text-sm text-slate-600">
          Add items from the catalog to build a basket.
        </p>
      ) : (
        <ul className="space-y-3">
          {items.map(({ item, quantity }) => (
            <li
              key={item.code}
              className="flex items-center justify-between rounded-xl border border-slate-200 bg-slate-50 px-4 py-3"
            >
              <div className="flex items-center gap-3">
                <span className="rounded-full bg-blue-50 px-2.5 py-1 text-xs font-semibold text-blue-600">
                  {item.code}
                </span>
                <span className="font-medium text-slate-900">{item.name}</span>
              </div>
              <div className="flex items-center gap-2">
                <span className="w-12 text-right font-medium text-slate-700">
                  × {quantity}
                </span>
                <button
                  type="button"
                  onClick={() => onAdd(item.code)}
                  aria-label={`Add one ${item.name}`}
                  className="flex h-8 w-8 items-center justify-center rounded-full bg-blue-600 text-white transition hover:bg-blue-500"
                >
                  +
                </button>
                <button
                  type="button"
                  onClick={() => onRemove(item.code)}
                  aria-label={`Remove one ${item.name}`}
                  className="flex h-8 w-8 items-center justify-center rounded-full bg-slate-200 text-slate-700 transition hover:bg-slate-300"
                >
                  −
                </button>
              </div>
            </li>
          ))}
        </ul>
      )}

      <div className="space-y-4 border-t border-slate-200 pt-4">
        <h3 className="text-lg font-semibold text-slate-900">Totals</h3>
        <dl className="space-y-3 text-sm text-slate-700">
          <div className="flex items-center justify-between">
            <dt>Subtotal</dt>
            <dd className="font-medium">
              {formatCurrency(parseFloat(totals.subtotal))}
            </dd>
          </div>
          <div className="flex items-center justify-between">
            <dt>Discount</dt>
            <dd className="font-medium text-rose-600">
              -{formatCurrency(parseFloat(totals.discount))}
            </dd>
          </div>
          <div className="flex items-center justify-between text-base font-semibold text-slate-900">
            <dt>Total</dt>
            <dd>{formatCurrency(parseFloat(totals.total))}</dd>
          </div>
        </dl>

        {hasItems && (
          <p className="text-sm text-slate-500">
            {isUpdating
              ? "Updating totals…"
              : "Totals reflect the current basket."}
          </p>
        )}

        {errorMessage ? (
          <p
            className="rounded-md border border-rose-200 bg-rose-50 px-3 py-2 text-sm text-rose-600"
            role="alert"
          >
            {errorMessage}
          </p>
        ) : null}
      </div>
    </section>
  );
}
