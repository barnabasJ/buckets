defmodule Buckets.Tracking.Schedule.Daily do
  use Ash.Resource, data_layer: :embedded, extensions: [AshGraphql.Resource]

  alias Buckets.Tracking.Schedule.Weekdays

  graphql do
    type :bucket_daily_schedule
  end

  attributes do
    attribute :type, :atom do
      allow_nil? false
      default :daily
      writable? false
    end

    attribute :weekdays, {:array, Weekdays} do
      public? true
    end

    attribute :minutes, :integer do
      public? true
      allow_nil? false
      default 0
    end
  end
end
