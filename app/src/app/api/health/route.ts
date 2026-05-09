import { NextResponse } from "next/server";

export async function GET() {
  console.log("Health check called at", new Date().toISOString());
  return NextResponse.json(
    { status: "ok", timestamp: new Date().toISOString() },
    { status: 200 }
  );
}
