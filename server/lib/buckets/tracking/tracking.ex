defmodule Buckets.Tracking do
  use Ash.Api

  resources do
    resource Buckets.Tracking.Bucket
    resource Buckets.Tracking.Entry
  end
end
