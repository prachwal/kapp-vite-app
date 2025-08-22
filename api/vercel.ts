import app from "./index.js";

export default async function handler(req: any, res: any) {
  return app(req, res);
}
