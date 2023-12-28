import { hydrateRoot } from "react-dom/client";
import { App } from "./app";
import { Provider } from "react-redux";
import { store } from "../store/store";
import { StrictMode, Suspense } from "react";

const domNode = document.getElementById("root");
hydrateRoot(
  domNode!,
  <StrictMode>
    <Provider store={store}>
      <App />
    </Provider>
  </StrictMode>
);
console.log("hydrated");
