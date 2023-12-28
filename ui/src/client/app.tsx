import { useEffect, useMemo, useState } from "react";
import { root } from "./app.css";
import { useBucketsQuery } from "./buckets.generated";
import SuspenseComponent from "./suspense";

export function App() {
  const m = useBucketsQuery();

  console.log(m);

  return (
    <div className={root}>
      <h1>Hello World!</h1>
      <SuspenseComponent />
    </div>
  );
}
