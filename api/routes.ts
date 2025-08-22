import express, { Request, Response } from "express";

const router = express.Router();

router.get("/health", (req: Request, res: Response) => {
  res.json({
    status: "ok",
    timestamp: new Date().toISOString(),
    api: "api",
    version: "v2",
  });
});

router.get("/hello", (req: Request, res: Response) => {
  res.json({ message: "hello", api: "api", version: "v2" });
});

export default router;
