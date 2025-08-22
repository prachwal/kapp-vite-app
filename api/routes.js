import express from "express";
const router = express.Router();

router.get("/health", (req, res) => {
  res.json({ status: "ok", timestamp: new Date().toISOString() });
});

router.get("/hello", (req, res) => {
  res.json({ message: "hello" });
});

export default router;
