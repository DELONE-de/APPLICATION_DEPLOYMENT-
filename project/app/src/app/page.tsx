import { Item } from "@/types/item";
import ItemList from "@/components/ItemList";
import ItemForm from "@/components/ItemForm";

async function getItems(): Promise<Item[]> {
  const res = await fetch(`${process.env.NEXT_PUBLIC_BASE_URL ?? ""}/api/items`, {
    cache: "no-store",
  });
  if (!res.ok) return [];
  return res.json();
}

export default async function Home() {
  const items = await getItems();
  return (
    <main>
      <h1>Items</h1>
      <ItemForm />
      <ItemList items={items} />
    </main>
  );
}
