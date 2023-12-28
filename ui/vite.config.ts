import { UserConfig, defineConfig } from "vite";
import { vanillaExtractPlugin } from "@vanilla-extract/vite-plugin";
import react from "@vitejs/plugin-react";

export default defineConfig((inputs): UserConfig => {
  return {
    plugins: [react(), vanillaExtractPlugin()],
  };
});
