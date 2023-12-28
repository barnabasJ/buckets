import { PassThrough } from "stream";
import { renderToPipeableStream } from "react-dom/server";
import { App } from "@src/client/app";
import { Provider } from "react-redux";
import { store } from "@src/store/store";

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
