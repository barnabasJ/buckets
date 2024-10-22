defmodule BucketsWeb.Tracking.Bucket.Form do
  use BucketsWeb, :live_component

  alias Buckets.Tracking.Bucket

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_form()}
  end

  defp assign_form(socket) do
    socket
    |> assign(
      :form,
      AshPhoenix.Form.for_create(Bucket, :create,
        actor: socket.assigns.current_user,
        forms: [auto?: true]
      )
      |> to_form()
    )
    |> dbg()
  end
end
