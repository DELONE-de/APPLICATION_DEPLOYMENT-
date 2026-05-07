"use client";

import { Item } from "@/types/item";

export default function ItemList({ items }: { items: Item[] }) {
  if (!items.length) return <p>No items found.</p>;
  return (
    <ul style={{ listStyle: "none", padding: 0 }}>
      {items.map((item) => (
        <li key={item.id} style={{ border: "1px solid #ddd", borderRadius: 6, padding: "1rem", marginBottom: "0.75rem" }}>
          <strong>{item.name}</strong>
          <p style={{ margin: "0.25rem 0 0" }}>{item.description}</p>
          <small style={{ color: "#888" }}>{new Date(item.createdAt).toLocaleString()}</small>
        </li>
      ))}
    </ul>
  );
}
