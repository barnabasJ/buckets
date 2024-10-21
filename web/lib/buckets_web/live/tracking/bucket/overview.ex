defmodule BucketsWeb.Tracking.Bucket.Overview do
  use BucketsWeb, :live_view

  alias Buckets.Tracking
  alias BucketsWeb.Tracking.Bucket.Overview.Components

  def mount(_params, _session, socket) do
    {:ok,
     assign(
       socket,
       :buckets,
       Tracking.read_buckets!(
         actor: socket.assigns.current_user,
         load: [:duration, :current_duration, entries: [:duration]]
       )
     )}
  end
end
