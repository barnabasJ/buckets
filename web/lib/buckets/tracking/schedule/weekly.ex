defmodule Buckets.Tracking.Schedule.Weekly do
  use Ash.Resource, data_layer: :embedded, extensions: [AshGraphql.Resource]

  alias Buckets.Tracking.Schedule.Weekdays

  attributes do
    attribute :type, :atom do
      allow_nil? false
      default :weekly
      writable? false
    end

    attribute :start_day, Weekdays do
      public? true
    end

    attribute :minutes, :integer do
      public? true
      allow_nil? false
      default 0
    end
  end

  graphql do
    type :bucket_weekly_schedule
  end
end
