import express from "express";
import apiRouter from "./routes.js";
import type { Request, Response, NextFunction } from "express";
import winston from "winston";

const app = express();

// configure winston
const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || "info",
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json()
  ),
  transports: [new winston.transports.Console()],
});

// request logging middleware
app.use((req: Request, res: Response, next: NextFunction) => {
  const start = Date.now();
  res.on("finish", () => {
    const ms = Date.now() - start;
    logger.info("http_request", {
      method: req.method,
      url: req.url,
      status: res.statusCode,
      duration_ms: ms,
    });
  });
  next();
});

app.use(express.json());
app.use("/api", apiRouter);

// error handling middleware (logs and returns JSON with api/version)
app.use((err: any, req: Request, res: Response, next: NextFunction) => {
  logger.error("api_error", {
    message: err && err.message,
    stack: err && err.stack,
  });
  const status = err && err.status ? err.status : 500;
  res.status(status).json({
    error: "internal_server_error",
    message: err && err.message ? err.message : "Internal Server Error",
    api: "api",
    version: "v2",
  });
});

export { logger };
export default app;

if (!process.env.VERCEL) {
  const port = process.env.PORT || 3000;
  app.listen(port, () => logger.info(`Listening: ${port}`));
}
