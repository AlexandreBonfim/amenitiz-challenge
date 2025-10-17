import { useMemo, useState } from "react";
import { useCheckout } from "./hooks/useCheckout";
import type { CartSummary } from "./types/checkout";
import "./App.css";
import { PageHeader } from "./components/PageHeader";
import { CatalogList } from "./components/CatalogList";
import { Basket, type GroupedCartItem } from "./components/Basket";
import { CATALOG } from "./constants";

const EMPTY_TOTALS: CartSummary = {
  subtotal: "0.00",
  discount: "0.00",
  total: "0.00",
};

function App() {
  const [cart, setCart] = useState<string[]>([]);
  const { data, isFetching, error } = useCheckout(cart);

  const totals = cart.length === 0 ? EMPTY_TOTALS : (data ?? EMPTY_TOTALS);

  const groupedCart = useMemo<GroupedCartItem[]>(() => {
    const groups = new Map<string, GroupedCartItem>();
    cart.forEach((code) => {
      const catalogItem = CATALOG.find((entry) => entry.code === code);
      if (!catalogItem) return;
      const current = groups.get(code);
      if (current) {
        current.quantity += 1;
      } else {
        groups.set(code, { item: catalogItem, quantity: 1 });
      }
    });
    return Array.from(groups.values());
  }, [cart]);

  const handleAdd = (code: string) => {
    setCart((prev) => [...prev, code]);
  };

  const handleRemove = (code: string) => {
    setCart((prev) => {
      const index = prev.lastIndexOf(code);
      if (index === -1) return prev;
      const next = [...prev];
      next.splice(index, 1);
      return next;
    });
  };

  const handleClear = () => setCart([]);

  const errorMessage = error instanceof Error ? error.message : undefined;
  const hasItems = cart.length > 0;

  return (
    <div className="mx-auto max-w-5xl space-y-10 px-4 py-12">
      <PageHeader
        title="Amenitiz Checkout"
        subtitle="Build a basket, apply pricing rules, and review the totals instantly with the Amenitiz catalog."
      />

      <main className="grid gap-8 lg:grid-cols-[minmax(0,1.05fr)_minmax(0,1fr)]">
        <CatalogList items={CATALOG} onAdd={handleAdd} />
        <Basket
          items={groupedCart}
          totals={totals}
          hasItems={hasItems}
          isUpdating={isFetching}
          errorMessage={errorMessage}
          onAdd={handleAdd}
          onRemove={handleRemove}
          onClear={handleClear}
        />
      </main>
    </div>
  );
}

export default App;
