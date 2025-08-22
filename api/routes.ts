import express from "express";
import type { Request, Response } from "express";
const router = express.Router();

router.get("/health", (req: Request, res: Response) => {
  res.json({ status: "ok", timestamp: new Date().toISOString() });
});

router.get("/hello", (req: Request, res: Response) => {
  res.json({ message: "hello" });
});

export default router;
