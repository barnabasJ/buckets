import { Plugin } from "vite";

/**
 * TODO: somehow this is stil injected by hydrate Root or something
 * this way the styleshit is always there, but is loaded twice
 *
 */
export function injectCss(): Plugin {
  return {
    name: "injectCss",
    apply: "build",
    transformIndexHtml(html, ctx) {
      const { bundle } = ctx;
      const cssLinkTags = Object.keys(bundle || {})
        .filter((key) => key.endsWith(".css"))
        .map((key) => bundle![key].fileName)
        .map((fileName) => `<link rel="stylesheet" href="/${fileName}">`)
        .join("\n");

      console.log({ html, cssLinkTags });

      return html.replace("<!--css-outlet-->", cssLinkTags);
    },
  };
}
