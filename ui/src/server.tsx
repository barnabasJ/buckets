import React from "react";
import { PassThrough } from "stream";
import { renderToPipeableStream } from "react-dom/server";
import { App } from "./app";
import { Provider } from "react-redux";
import { store } from "./store";

export function render() {
  const stream = new PassThrough();
  return new Promise((resolve, reject) => {
    const { pipe } = renderToPipeableStream(
      <Provider store={store}>
        <App />
      </Provider>,

      {
        onShellReady: () => {
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
