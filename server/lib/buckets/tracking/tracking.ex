defmodule Buckets.Tracking do
  use Ash.Domain

  resources do
    resource Buckets.Tracking.Bucket
    resource Buckets.Tracking.Entry
  end
end
