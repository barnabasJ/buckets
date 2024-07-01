defmodule Buckets.Tracking.Schedule.Weekdays do
  use Ash.Type.Enum,
    values: [
      :monday,
      :tuesday,
      :wednesday,
      :thursday,
      :friday,
      :saturday,
      :sunday
    ]

  def graphql_type(_), do: :bucket_weekdays_schedule
end
