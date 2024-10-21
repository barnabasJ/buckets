defmodule Buckets.Tracking do
  use Ash.Domain

  resources do
    resource Buckets.Tracking.Bucket do
      define :read_buckets, action: :read
      define :get_bucket_by_id, action: :read, get_by: :id
    end

    resource Buckets.Tracking.Entry
  end
end
