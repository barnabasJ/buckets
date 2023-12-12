import { defineConfig } from "vite";
import devServer from "@hono/vite-dev-server";
import react from "@vitejs/plugin-react";

export default defineConfig(({ mode }) => {
  if (mode === "client") {
    return {
      plugins: [react()],
      build: {
        entry: "./src/client.tsx",
        rollupOptions: {
          input: "./src/client.tsx",
          output: {
            entryFileNames: "[name].js",
            dir: "./dist/client/assets",
          },
        },
        emptyOutDir: false,
        copyPublicDir: false,
      },
    };
  } else {
    return {
      build: {
        ssr: true,
        lib: {
          entry: "./src/server.tsx",
          formats: ["es"],
          fileName: "server",
          name: "server",
        },
        rollupOptions: {
          output: {
            dir: "./dist",
          },
        },
      },
      plugins: [
        react(),
        devServer({
          entry: "src/server.tsx",
        }),
      ],
    };
  }
});
