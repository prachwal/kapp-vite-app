import express from "express";
import { dirname } from "path";
import { fileURLToPath } from "url";
import apiRouter from "./routes.js";

const __dirname = dirname(fileURLToPath(import.meta.url));
const app = express();

app.use(express.json());
app.use("/api", apiRouter);

export default app;

if (!process.env.VERCEL) {
  const port = process.env.PORT || 5173;
  app.listen(port, () => console.log(`Listening ${port}`));
}
