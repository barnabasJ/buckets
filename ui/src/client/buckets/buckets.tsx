import { useBucketsQuery, useNewBucketMutation } from "./buckets.generated";

import { bucket } from "./buckets.css";
import { useState } from "react";

export default function Buckets() {
  const { data, isLoading, refetch } = useBucketsQuery();
  const [newBucket, { isLoading: mutationIsLoading }] = useNewBucketMutation();
  const disabled = isLoading || mutationIsLoading;
  const [scheduleType, setScheduleType] = useState("");

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
            await newBucket({
              name: formData.get("name") as string,
              schedule: scheduleInputFromFormData(formData),
            });
            refetch();
          }}
        >
          <div>
            <label htmlFor="name">Name</label>
            <input required type="text" id="name" name="name" />
          </div>
          <div>
            <label htmlFor="scheduleType">Name</label>
            <select
              required
              id="scheduleType"
              name="scheduleType"
              defaultValue=""
              onChange={(e) => setScheduleType(e.target.value)}
            >
              <option value="">Please select a schedule type</option>
              <option value="daily">Daily</option>
              <option value="weekly">Weekly</option>
            </select>
          </div>{" "}
          {scheduleType === "daily" ? (
            <div>
              <div>
                <label htmlFor="minutes">Minutes</label>
                <input type="integer" name="minutes" id="minutes" />
              </div>
              <div>
                <p>Weekdays</p>
                <div>
                  <label htmlFor="monday">Monday</label>
                  <input type="radio" name="monday" id="monday" />
                </div>
                <div>
                  <label htmlFor="tuesday">Tuesday</label>
                  <input type="radio" name="tuesday" id="tuesday" />
                </div>
                <div>
                  <label htmlFor="wednesday">Wednesday</label>
                  <input type="radio" name="wednesday" id="wednesday" />
                </div>
                <div>
                  <label htmlFor="thursday">Thursday</label>
                  <input type="radio" name="thursday" id="thursday" />
                </div>
                <div>
                  <label htmlFor="friday">Friday</label>
                  <input type="radio" name="friday" id="friday" />
                </div>
                <div>
                  <label htmlFor="saturday">Saturday</label>
                  <input type="radio" name="saturday" id="saturday" />
                </div>
                <div>
                  <label htmlFor="sunday">Sunday</label>
                  <input type="radio" name="sunday" id="sunday" />
                </div>
              </div>
            </div>
          ) : null}
          <button type="submit">Create</button>
        </form>
      </div>
      {isLoading && <p>Loading...</p>}
      {data?.buckets?.length ? (
        <ul>
          {data?.buckets?.map((bucket) => (
            <li key={bucket.id}>
              <p>{bucket.name}</p>
              <progress
                value={bucket.currentDuration}
                max={bucket.schedule.minutes}
              />
            </li>
          ))}
        </ul>
      ) : null}
    </div>
  );
}

function scheduleInputFromFormData(formdata: FormData) {
  const type = formdata.get("scheduleType");

  if (type === "daily") {
    return {
      daily: {
        minutes: Number.parseInt(
          (formdata.get("minutes") as string) || "0",
          10
        ),
        weekdays: [
          formdata.get("monday") && "MONDAY",
          formdata.get("tuesday") && "TUESDAY",
          formdata.get("wednesday") && "WEDNESDAY",
          formdata.get("thursday") && "THURSDAY",
          formdata.get("friday") && "FRIDAY",
          formdata.get("saturday") && "SATURDAY",
          formdata.get("sunday") && "SUNDAY",
        ].filter(Boolean),
      },
    };
  }
}
