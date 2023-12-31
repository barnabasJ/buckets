import { PassThrough } from "stream";
import { renderToPipeableStream } from "react-dom/server";
import { App } from "@src/client/app";
import { Provider } from "react-redux";
import { store } from "@src/store/store";
import { StrictMode } from "react";
import { Router } from "wouter";
import { FastifyRequest } from "fastify";

export function render(req: FastifyRequest) {
  const stream = new PassThrough();
  return new Promise((resolve, reject) => {
    const { pipe } = renderToPipeableStream(
      <StrictMode>
        <Router ssrPath={req.url}>
          <Provider store={store}>
            <App />
          </Provider>
        </Router>
      </StrictMode>,
      {
        // use onAllReady for now as we do not load data inside the tree
        // and suspense with lazy somehow isn't working on the first request
        onAllReady: (...args) => {
          console.log("onShellReady", args);
          pipe(stream);
          resolve(stream);
        },
        onError: (err) => {
          reject(err);
        },
      }
    );
  });
}
