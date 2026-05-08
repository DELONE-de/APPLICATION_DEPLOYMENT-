"use client";

import { Item } from "@/types/item";

export default function ItemList({ items }: { items: Item[] }) {
  if (!items.length) return <p className="empty">No items found.</p>;
  return (
    <ul className="item-list">
      {items.map((item) => (
        <li key={item.id} className="item-card">
          <p className="item-name">{item.name}</p>
          <p className="item-description">{item.description}</p>
          <span className="item-date">{new Date(item.createdAt).toLocaleString()}</span>
        </li>
      ))}
    </ul>
  );
}
