"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";

export default function ItemForm() {
  const router = useRouter();
  const [name, setName] = useState("");
  const [description, setDescription] = useState("");
  const [loading, setLoading] = useState(false);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setLoading(true);
    await fetch("/api/items", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ name, description }),
    });
    setName("");
    setDescription("");
    setLoading(false);
    router.refresh();
  }

  return (
    <form onSubmit={handleSubmit} style={{ marginBottom: "2rem", display: "flex", flexDirection: "column", gap: "0.5rem", maxWidth: 400 }}>
      <input
        required
        placeholder="Name"
        value={name}
        onChange={(e) => setName(e.target.value)}
        style={{ padding: "0.5rem", borderRadius: 4, border: "1px solid #ccc" }}
      />
      <textarea
        placeholder="Description"
        value={description}
        onChange={(e) => setDescription(e.target.value)}
        style={{ padding: "0.5rem", borderRadius: 4, border: "1px solid #ccc" }}
      />
      <button type="submit" disabled={loading} style={{ padding: "0.5rem 1rem", borderRadius: 4, cursor: "pointer" }}>
        {loading ? "Adding..." : "Add Item"}
      </button>
    </form>
  );
}
