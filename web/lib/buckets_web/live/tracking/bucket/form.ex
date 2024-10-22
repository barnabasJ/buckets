defmodule BucketsWeb.Tracking.Bucket.Form do
  use BucketsWeb, :live_component

  alias Buckets.Tracking.Bucket
  alias Buckets.Tracking.Schedule.Weekdays

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
      |> AshPhoenix.Form.add_form(:schedule, params: %{"_union_type" => "daily"})
      |> to_form()
    )
  end

  @impl true
  def handle_event("type-changed", %{"_target" => path} = params, socket) do
    dbg(params)
    new_type = get_in(params, path)
    # The last part of the path in this case is the field name
    path = :lists.droplast(path)

    form =
      socket.assigns.form
      |> AshPhoenix.Form.remove_form(path)
      |> AshPhoenix.Form.add_form(path, params: %{"_union_type" => new_type})

    {:noreply, assign(socket, :form, form)}
  end

  @impl true
  def handle_event("save", %{"form" => form_params} = params, socket) do
    dbg(params)

    case AshPhoenix.Form.submit(socket.assigns.form, params: form_params) do
      {:ok, entry} ->
        {:noreply,
         socket
         |> put_flash(:info, "Bucket created")
         |> assign_form()}

      {:error, form} ->
        {:noreply,
         socket
         |> put_flash(:error, "Failed to start entry")
         |> assign(form: form)}
    end
  end
end
