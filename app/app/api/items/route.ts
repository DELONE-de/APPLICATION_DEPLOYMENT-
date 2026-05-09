import { NextRequest, NextResponse } from "next/server";
import { ScanCommand, PutCommand } from "@aws-sdk/lib-dynamodb";
import { db, TABLE_NAME } from "@/lib/dynamodb";
import { randomUUID } from "crypto";

export async function GET() {
  try {
    const result = await db.send(new ScanCommand({ TableName: TABLE_NAME }));
    return NextResponse.json(result.Items ?? []);
  } catch (err) {
    console.error("[GET /api/items]", err);
    return NextResponse.json({ error: "Failed to fetch items" }, { status: 500 });
  }
}

export async function POST(req: NextRequest) {
  try {
    const body = await req.json();
    const item = {
      id: randomUUID(),
      name: body.name,
      description: body.description ?? "",
      createdAt: new Date().toISOString(),
    };
    await db.send(new PutCommand({ TableName: TABLE_NAME, Item: item }));
    return NextResponse.json(item, { status: 201 });
  } catch (err) {
    console.error("[POST /api/items]", err);
    return NextResponse.json({ error: "Failed to create item" }, { status: 500 });
  }
}
