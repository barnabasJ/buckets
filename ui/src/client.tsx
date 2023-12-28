import React from "react";
import { hydrateRoot } from "react-dom/client";
import { App } from "./app";
import { Provider } from "react-redux";
import { store } from "./store";

const domNode = document.getElementById("root");
hydrateRoot(
  domNode!,
  <Provider store={store}>
    <App />
  </Provider>
);
console.log("hydrated");
