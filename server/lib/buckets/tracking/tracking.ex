defmodule Buckets.Tracking do
  use Ash.Api

  resources do
    resource Buckets.Tracking.Bucket
  end
end
