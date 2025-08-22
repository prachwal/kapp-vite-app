import app from "./index.js";

// Vercel's Node runtime passes a (req, res) compatible with Express.
export default async function handler(req: any, res: any) {
  return (app as any)(req, res);
}
