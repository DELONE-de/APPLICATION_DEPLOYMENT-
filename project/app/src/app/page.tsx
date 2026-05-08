import { Item } from "@/types/item";
import { db, TABLE_NAME } from "@/lib/dynamodb";
import { ScanCommand } from "@aws-sdk/lib-dynamodb";
import ItemList from "@/components/ItemList";
import ItemForm from "@/components/ItemForm";

async function getItems(): Promise<Item[]> {
  try {
    const result = await db.send(new ScanCommand({ TableName: TABLE_NAME }));
    return (result.Items ?? []) as Item[];
  } catch {
    return [];
  }
}

export default async function Home() {
  const items = await getItems();
  return (
    <main>
      <h1 className="page-title">Items</h1>
      <ItemForm />
      <ItemList items={items} />
    </main>
  );
}
