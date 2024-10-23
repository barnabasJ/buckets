defmodule BucketsWeb.Tracking.Bucket.Overview do
  use BucketsWeb, :live_view

  alias Buckets.Tracking
  alias BucketsWeb.Tracking.Bucket.Overview.Components
  alias BucketsWeb.Tracking.Bucket.Form

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign_buckets()}
  end

  @loads [:duration, :current_duration, finished_entries: [:duration]]

  defp assign_buckets(socket) do
    socket
    |> stream(
      :buckets,
      Tracking.read_buckets!(
        actor: socket.assigns.current_user,
        load: @loads,
        query: Tracking.Bucket |> Ash.Query.sort(inserted_at: :desc)
      )
    )
  end

  @impl true
  def handle_info({:bucket_created, bucket}, socket) do
    {:noreply,
     socket
     |> stream_insert(
       :buckets,
       bucket |> Ash.load!(@loads, actor: socket.assigns.current_user)
     )}
  end
end
