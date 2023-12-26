import { Plugin } from "vite";

export default function myVitePlugin(): Plugin {
  return {
    name: "my-vite-plugin",
    transform(code, id, options) {
      console.log(id);
      return code;
    },
  };
}
