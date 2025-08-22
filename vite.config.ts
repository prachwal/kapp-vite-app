import { defineConfig } from "vite";
import { svelte } from "@sveltejs/vite-plugin-svelte";
import { readFileSync } from "fs";
import { resolve } from "path";

// read package.json version
const pkg = JSON.parse(
  readFileSync(resolve(__dirname, "package.json"), "utf-8")
);
const APP_VERSION = pkg.version || "0.0.0";

// https://vite.dev/config/
export default defineConfig({
  plugins: [svelte()],
  define: {
    __APP_VERSION__: JSON.stringify(APP_VERSION),
  },
  server: {
    proxy: {
      "/api": {
        target: "http://localhost:3000",
        changeOrigin: true,
        secure: false,
      },
    },
  },
});
