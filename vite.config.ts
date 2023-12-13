import { UserConfig, defineConfig } from "vite";
import devServer from "@hono/vite-dev-server";
import { vanillaExtractPlugin } from "@vanilla-extract/vite-plugin";
import react from "@vitejs/plugin-react";

export default defineConfig(({ mode }): UserConfig => {
  if (mode === "client") {
    return {
      plugins: [react(), vanillaExtractPlugin({ emitCssInSsr: true })],
      build: {
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
      ssr: {
        target: "webworker",
        // noExternal: true,
      },
      plugins: [
        react(),
        vanillaExtractPlugin(),
        devServer({
          entry: "src/server.tsx",
        }),
      ],
    };
  }
});
