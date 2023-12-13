import { UserConfig, defineConfig } from "vite";
import devServer from "@hono/vite-dev-server";
import { vanillaExtractPlugin } from "@vanilla-extract/vite-plugin";
import react from "@vitejs/plugin-react";

export default defineConfig((inputs): UserConfig => {
  console.log({ inputs });
  const mode = inputs.mode;
  if (inputs.isSsrBuild) {
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
        vanillaExtractPlugin({ emitCssInSsr: false }),
        devServer({
          entry: "src/server.tsx",
        }),
      ],
    };
  } else {
    return {
      plugins: [react(), vanillaExtractPlugin()],
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
  }
});
