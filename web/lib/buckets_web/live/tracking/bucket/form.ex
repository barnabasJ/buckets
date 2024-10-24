defmodule BucketsWeb.Tracking.Bucket.Form do
  use BucketsWeb, :live_component

  alias Buckets.Tracking.Bucket
  alias Buckets.Tracking.Schedule.Weekdays
  alias BucketsWeb.Form.MultiSelect

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_form()}
  end

  defp assign_form(socket) do
    if socket.assigns[:form][:schedule] do
      if List.first(socket.assigns.form[:schedule].value).params["_union_type"] == "daily" and
           socket.assigns[:updated_options] do
        params =
          socket.assigns.form
          |> AshPhoenix.Form.params()
          |> put_in(
            [
              "schedule",
              "weekdays"
            ],
            socket.assigns[:updated_options]
            |> Enum.filter(& &1.selected)
            |> Enum.map(& &1.label)
          )

        socket
        |> assign(
          :form,
          AshPhoenix.Form.add_form(socket.assigns.form, :schedule, params: params["schedule"])
        )
        |> assign(
          :options,
          Weekdays.values()
          |> Enum.map(&{&1, to_string(&1)})
          |> Enum.map(fn data ->
            %{
              id: elem(data, 1),
              label: elem(data, 1),
              selected: elem(data, 1) in params["schedule"]["weekdays"]
            }
          end)
        )
      else
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
        |> assign(
          :options,
          Weekdays.values()
          |> Enum.map(&{&1, to_string(&1)})
          |> Enum.map(fn data ->
            %{
              id: elem(data, 1),
              label: elem(data, 1),
              selected: false
            }
          end)
        )
      end
    else
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
      |> assign(
        :options,
        Weekdays.values()
        |> Enum.map(&{&1, to_string(&1)})
        |> Enum.map(fn data ->
          %{
            id: elem(data, 1),
            label: elem(data, 1),
            selected: false
          }
        end)
      )
    end
  end

  @impl true

  def handle_event("validate", %{"form" => form_params}, socket) do
    {:noreply,
     socket
     |> assign(
       :form,
       socket.assigns.form
       |> AshPhoenix.Form.validate(form_params)
     )}
  end

  @impl true
  def handle_event("type-changed", %{"_target" => path} = params, socket) do
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
  def handle_event("save", %{"form" => form_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: form_params) do
      {:ok, bucket} ->
        send(self(), {:bucket_created, bucket})

        {:noreply,
         socket
         |> put_flash(:info, "Bucket created")
         |> assign(:updated_options, nil)
         |> assign_form()}

      {:error, form} ->
        {:noreply,
         socket
         |> put_flash(:error, "Failed to start entry")
         |> assign(form: form)}
    end
  end
end
