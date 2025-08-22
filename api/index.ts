import express from "express";
import apiRouter from "./routes.js";
const app = express();

app.use(express.json());
app.use("/api", apiRouter);

export default app;

if (!process.env.VERCEL) {
  const port = process.env.PORT || 3000;
  app.listen(port, () => console.log(`Listening ${port}`));
}
