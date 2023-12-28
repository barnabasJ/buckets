import { root } from "./app.css";
import { useBucketsQuery } from "./buckets.generated";

export function App() {
  const m = useBucketsQuery();

  console.log(m);

  return (
    <div className={root}>
      <h1>Hello World!</h1>
    </div>
  );
}
