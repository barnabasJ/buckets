defmodule BucketsWeb.Tracking.Bucket.Overview do
  use BucketsWeb, :live_view

  alias Buckets.Tracking
  alias BucketsWeb.Tracking.Bucket.Overview.Components
  alias BucketsWeb.Tracking.Bucket.Form

  def mount(_params, _session, socket) do
    {:ok, socket |> assign_buckets()}
  end

  defp assign_buckets(socket) do
    socket
    |> assign(
      :buckets,
      Tracking.read_buckets!(
        actor: socket.assigns.current_user,
        load: [:duration, :current_duration, finished_entries: [:duration]]
      )
    )
  end
end
