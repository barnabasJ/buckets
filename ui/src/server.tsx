import React from "react";
import { PassThrough } from "stream";
import { renderToPipeableStream } from "react-dom/server";
import { App } from "./app";

export function render() {
  const stream = new PassThrough();
  return new Promise((resolve, reject) => {
    const { pipe } = renderToPipeableStream(<App />, {
      onShellReady: () => {
        pipe(stream);
        resolve(stream);
      },
      onError: (err) => {
        reject(err);
      },
    });
  });
}
