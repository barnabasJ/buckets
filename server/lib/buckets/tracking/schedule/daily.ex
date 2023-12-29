defmodule Buckets.Tracking.Schedule.Daily do
  use Ash.Resource, data_layer: :embedded, extensions: [AshGraphql.Resource]

  attributes do
    attribute :type, :atom do
      allow_nil? false
      default :daily
      writable? false
    end

    attribute :weekdays, {:array, :atom} do
      constraints items: [
                    one_of: [
                      :monday,
                      :tuesday,
                      :wednesday,
                      :thursday,
                      :friday,
                      :saturday,
                      :sunday
                    ]
                  ]
    end

    attribute :minutes, :integer do
      allow_nil? false
      default 0
    end
  end

  graphql do
    type :bucket_daily_schedule
  end
end
