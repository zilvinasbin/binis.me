import sitemap from "@astrojs/sitemap";
import tailwind from "@astrojs/tailwind";
import { defineConfig } from "astro/config";

// https://astro.build/config
export default defineConfig({
  integrations: [
    sitemap(),
    tailwind(),
  ],
  site: "https://binis.me",
  compressHTML: true,
  vite: {
    server: {
      host: '0.0.0.0',
      port: 4323,
      hmr: false,
    },
    preview: {
      host: '0.0.0.0',
      port: 4323,
      allowedHosts: [
        'binis.me',
        'www.binis.me',
        'localhost',
        '127.0.0.1',
        '0.0.0.0'
      ]
    }
  }
});
