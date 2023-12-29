import { hydrateRoot } from "react-dom/client";
import { App } from "./app";
import { Provider } from "react-redux";
import { store } from "../store/store";
import { StrictMode, Suspense } from "react";
import { Router } from "wouter";

const domNode = document.getElementById("root");
hydrateRoot(
  domNode!,
  <StrictMode>
    <Router>
      <Provider store={store}>
        <App />
      </Provider>
    </Router>
  </StrictMode>
);
console.log("hydrated");
