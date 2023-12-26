import fs from "fs";
import Fastify from "fastify";
import path from "path";
import { fileURLToPath } from "url";
import { ViteDevServer, createServer as createViteServer } from "vite";
import middie from "@fastify/middie";
import fastifyStatic from "@fastify/static";

const __dirname = path.dirname(fileURLToPath(import.meta.url));

const isProduction = process.env.NODE_ENV === "production";
console.log("isProduction", isProduction);

async function createServer() {
  const fastify = Fastify({ logger: true });

  let vite: ViteDevServer;
  if (!isProduction) {
    await fastify.register(middie);

    // Create Vite server in middleware mode and configure the app type as
    // 'custom', disabling Vite's own HTML serving logic so parent server
    // can take control
    vite = await createViteServer({
      server: { middlewareMode: true },
      appType: "custom",
    });

    // Use vite's connect instance as middleware. If you use your own
    // express router (express.Router()), you should use router.use
    // When the server restarts (for example after the user modifies
    // vite.config.js), `vite.middlewares` is still going to be the same
    // reference (with a new internal stack of Vite and plugin-injected
    // middlewares. The following is valid even after restarts.
    fastify.use(vite.middlewares);
  } else {
    fastify.register(fastifyStatic, {
      root: path.resolve(__dirname, "./dist/client"),
    });
  }

  const { render } = await (isProduction
    ? // @ts-expect-error
      import("./dist/server/server.js")
    : // @ts-expect-error
      vite.ssrLoadModule("./src/server.tsx"));

  let template = fs.readFileSync(
    path.resolve(
      __dirname,
      `${isProduction ? "./dist/client/" : ""}index.html`
    ),
    "utf-8"
  );

  fastify.get("/", async (req, res) => {
    const url = req.originalUrl;

    try {
      // 1. Read index.html

      // 2. Apply Vite HTML transforms. This injects the Vite HMR client,
      //    and also applies HTML transforms from Vite plugins, e.g. global
      //    preambles from @vitejs/plugin-react
      if (!isProduction) {
        template = await vite.transformIndexHtml(url, template);
      }

      // 3. Load the server entry. ssrLoadModule automatically transforms
      //    ESM source code to be usable in Node.js! There is no bundling
      //    required, and provides efficient invalidation similar to HMR.
      // 4. render the app HTML. This assumes entry-server.js's exported
      //     `render` function calls appropriate framework SSR APIs,
      //    e.g. ReactDOMServer.renderToString()
      const appHtml = await render(url);

      // 5. Inject the app-rendered HTML into the template.
      const html = template.replace(`<!--ssr-outlet-->`, appHtml);

      // 6. Send the rendered HTML back.
      res.statusCode = 200;

      res.header("Content-Type", "text/html");
      return html;
    } catch (e) {
      // If an error is caught, let Vite fix the stack trace so it maps back
      // to your actual source code.
      if (e instanceof Error) {
        vite?.ssrFixStacktrace(e);
      }
      throw e;
    }
  });

  fastify.listen({ port: 5173 });
}

createServer();
