import { NextRequest, NextResponse } from "next/server";
import { GetCommand, PutCommand, DeleteCommand } from "@aws-sdk/lib-dynamodb";
import { db, TABLE_NAME } from "@/lib/dynamodb";

type Params = { params: { id: string } };

export async function GET(_: NextRequest, { params }: Params) {
  const result = await db.send(
    new GetCommand({ TableName: TABLE_NAME, Key: { id: params.id } })
  );
  if (!result.Item) return NextResponse.json({ error: "Not found" }, { status: 404 });
  return NextResponse.json(result.Item);
}

export async function PUT(req: NextRequest, { params }: Params) {
  const body = await req.json();
  const item = { id: params.id, ...body };
  await db.send(new PutCommand({ TableName: TABLE_NAME, Item: item }));
  return NextResponse.json(item);
}

export async function DELETE(_: NextRequest, { params }: Params) {
  await db.send(
    new DeleteCommand({ TableName: TABLE_NAME, Key: { id: params.id } })
  );
  return NextResponse.json({ deleted: true });
}
