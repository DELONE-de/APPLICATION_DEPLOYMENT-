import { NextRequest, NextResponse } from "next/server";
import { ScanCommand, PutCommand } from "@aws-sdk/lib-dynamodb";
import { db, TABLE_NAME } from "@/lib/dynamodb";
import { randomUUID } from "crypto";

export async function GET() {
  const result = await db.send(new ScanCommand({ TableName: TABLE_NAME }));
  return NextResponse.json(result.Items ?? []);
}

export async function POST(req: NextRequest) {
  const body = await req.json();
  const item = {
    id: randomUUID(),
    name: body.name,
    description: body.description ?? "",
    createdAt: new Date().toISOString(),
  };
  await db.send(new PutCommand({ TableName: TABLE_NAME, Item: item }));
  return NextResponse.json(item, { status: 201 });
}
