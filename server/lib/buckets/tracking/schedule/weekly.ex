defmodule Buckets.Tracking.Schedule.Weekly do
  use Ash.Resource, data_layer: :embedded, extensions: [AshGraphql.Resource]

  attributes do
    attribute :type, :atom do
      allow_nil? false
      default :weekly
      writable? false
    end

    attribute :start_day, :atom do
      constraints one_of: [
                    :monday,
                    :tuesday,
                    :wednesday,
                    :thursday,
                    :friday,
                    :saturday,
                    :sunday
                  ]
    end

    attribute :minutes, :integer do
      allow_nil? false
      default 0
    end
  end

  graphql do
    type :bucket_weekly_schedule
  end
end
