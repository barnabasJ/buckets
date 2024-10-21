import { Suspense, memo, lazy } from "react";
import { Switch, Route } from "wouter";

const Buckets = lazy(() => import("./buckets/buckets"));

function Router() {
  return (
    <Suspense>
      <Switch>
        <Route path="/">
          <Buckets />
        </Route>
        <Route>
          <div>404</div>
        </Route>
      </Switch>
    </Suspense>
  );
}

export default memo(Router);
