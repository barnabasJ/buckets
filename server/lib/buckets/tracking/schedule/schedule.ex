defmodule Buckets.Tracking.Schedule do
  @moduledoc """
  The Union of all possible TravelPlanItems
  """
  alias Buckets.Tracking.Schedule.Weekly
  alias Buckets.Tracking.Schedule.Daily

  @types [
    weekly: [
      type: Weekly,
      tag: :type,
      tag_value: :weekly
    ],
    daily: [
      type: Daily,
      tag: :type,
      tag_value: :daily
    ]
  ]

  @structs_to_names Keyword.new(@types, fn {key, value} -> {value[:type], key} end)

  use Ash.Type.NewType,
    subtype_of: :union,
    constraints: [
      types: @types
    ]

  def struct_to_name(%struct{}), do: @structs_to_names[struct]

  def graphql_type, do: :bucket_schedule

  # Tells AshGrapqhl to use the graphql types from the embedded
  # resources inside the union instead of creating new ones
  def graphql_unnested_unions(_), do: Keyword.keys(@types)
end
