import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "App",
  description: "Next.js fullstack app",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body style={{ fontFamily: "sans-serif", maxWidth: 800, margin: "0 auto", padding: "2rem" }}>
        {children}
      </body>
    </html>
  );
}
