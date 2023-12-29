import { useBucketsQuery, useNewBucketMutation } from "./buckets.generated";

import { bucket } from "./buckets.css";

export default function Buckets() {
  const { data, isLoading, refetch } = useBucketsQuery();
  const [newBucket, { isLoading: mutationIsLoading }] = useNewBucketMutation();
  const disabled = isLoading || mutationIsLoading;

  console.log({ isLoading, mutationIsLoading, disabled });

  return (
    <div>
      <h1 className={bucket}>Buckets</h1>
      <div>
        <h2>New Bucket</h2>
        <form
          onSubmit={async (e) => {
            e.preventDefault();
            const formData = new FormData(e.currentTarget);
            console.log(formData);
            await newBucket({ name: formData.get("name") as string });
            refetch();
          }}
        >
          <div>
            <label htmlFor="name">Name</label>
            <input required type="text" id="name" name="name" />
          </div>
          <button type="submit">Create</button>
        </form>
      </div>
      {isLoading && <p>Loading...</p>}
      {data?.buckets?.length ? (
        <ul>
          {data?.buckets?.map((bucket) => (
            <li key={bucket.id}>{bucket.name}</li>
          ))}
        </ul>
      ) : null}
    </div>
  );
}
