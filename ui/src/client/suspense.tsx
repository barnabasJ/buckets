import { Suspense, lazy, memo } from "react";

const LazyComponent = lazy(() => import("./lazy-component"));

export function SuspenseComponent() {
  return (
    <Suspense fallback={<p>Loading...</p>}>
      <LazyComponent />
    </Suspense>
  );
}

// do this for now, because otherwise the suspense component is rendered again
// because the redux store is updated because of the query and this leads to
// this error:
//
// This Suspense boundary received an update before it finished hydrating.
// This caused the boundary to switch to client rendering.
// The usual way to fix this is to wrap the original update in startTransition.
//
export default memo(SuspenseComponent);
