import type { CatalogItem } from "../types/catalog";
import { formatCurrency } from "../utils/currency";

type CatalogListProps = {
  items: CatalogItem[];
  onAdd: (code: string) => void;
};

export function CatalogList({ items, onAdd }: CatalogListProps) {
  return (
    <section className="space-y-6 rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
      <div className="flex items-baseline justify-between gap-4">
        <h2 className="text-xl	font-semibold text-slate-900">Catalog</h2>
        <span className="text-sm text-slate-500">{items.length} items</span>
      </div>

      <ul className="space-y-4">
        {items.map((product) => (
          <li
            key={product.code}
            className="rounded-xl border border-slate-200/80 bg-slate-50 p-4 shadow-sm transition hover:border-slate-300"
          >
            <div className="flex items-center justify-between gap-4">
              <div className="space-y-1">
                <span className="inline-flex items-center rounded-full bg-blue-50 px-3 py-1 text-xs font-semibold text-blue-600">
                  {product.code}
                </span>
                <h3 className="text-lg font-medium text-slate-900">
                  {product.name}
                </h3>
              </div>
              <span className="text-lg font-semibold text-slate-900">
                {formatCurrency(product.price)}
              </span>
            </div>
            {product.description ? (
              <p className="mt-3 text-sm text-slate-600">
                {product.description}
              </p>
            ) : null}
            <button
              type="button"
              onClick={() => onAdd(product.code)}
              className="mt-4 inline-flex items-center gap-2 rounded-full bg-blue-600 px-4 py-2 text-sm font-semibold text-white shadow-sm transition hover:bg-blue-500 focus:outline-none focus-visible:ring-2 focus-visible:ring-blue-600 focus-visible:ring-offset-2"
            >
              Add to basket
            </button>
          </li>
        ))}
      </ul>
    </section>
  );
}
