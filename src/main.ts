import { mount } from "svelte";
import "./app.css";
import App from "./App.svelte";

import { injectSpeedInsights } from "@vercel/speed-insights";

// Keep speed insights, but remove @vercel/analytics which imports SvelteKit-only
// modules that break Vite builds in this app setup.
injectSpeedInsights();

const app = mount(App, {
  target: document.getElementById("app")!,
});

// Injected at build time by Vite define
declare const __APP_VERSION__: string;
const APP_VERSION =
  typeof __APP_VERSION__ !== "undefined" ? __APP_VERSION__ : "dev";
console.info("app version:", APP_VERSION);

export default app;
