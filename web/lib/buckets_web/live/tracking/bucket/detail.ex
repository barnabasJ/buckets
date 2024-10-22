defmodule BucketsWeb.Tracking.Bucket.Detail do
  use BucketsWeb, :live_view

  alias Buckets.Tracking
  alias BucketsWeb.Tracking.Bucket.Overview.Components

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign_bucket(params["id"])
     |> assign_current_entry()
     |> assign_entry_start_form()
     |> assign_entry_stop_form()
     |> assign_entry_description_form()}
  end

  @loads [:duration, :current_duration, :current_entry, finished_entries: [:duration]]

  defp assign_bucket(socket, id) when is_binary(id) do
    socket
    |> assign(
      :bucket,
      Tracking.get_bucket_by_id!(id,
        actor: socket.assigns.current_user,
        load: @loads
      )
    )
  end

  defp assign_bucket(socket, bucket) when is_struct(bucket, Tracking.Bucket) do
    socket
    |> assign(
      :bucket,
      bucket
      |> Ash.load!(@loads,
        actor: socket.assigns.current_user
      )
    )
  end

  defp assign_current_entry(socket, entry \\ nil) do
    socket
    |> assign(
      :current_entry,
      entry || socket.assigns.bucket.current_entry
    )
  end

  defp assign_entry_start_form(socket) do
    socket
    |> assign(
      :entry_start_form,
      AshPhoenix.Form.for_create(Tracking.Entry, :start, actor: socket.assigns.current_user)
      |> to_form()
      |> dbg()
    )
  end

  defp assign_entry_stop_form(socket) do
    socket
    |> assign(
      :entry_stop_form,
      if socket.assigns.current_entry do
        AshPhoenix.Form.for_update(socket.assigns.current_entry, :stop,
          actor: socket.assigns.current_user
        )
        |> to_form()
      else
        nil
      end
    )
  end

  defp assign_entry_description_form(socket) do
    socket
    |> assign(
      :entry_description_form,
      if socket.assigns.current_entry do
        AshPhoenix.Form.for_update(socket.assigns.current_entry, :update,
          actor: socket.assigns.current_user
        )
        |> to_form()
      else
        nil
      end
    )
  end

  @impl true
  def handle_event("start_entry", %{"form" => form_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.entry_start_form, params: form_params) do
      {:ok, entry} ->
        {:noreply,
         socket
         |> put_flash(:info, "Entry started")
         |> assign_current_entry(entry)
         |> assign_entry_start_form()
         |> assign_entry_stop_form()}

      {:error, form} ->
        {:noreply,
         socket
         |> put_flash(:error, "Failed to start entry")
         |> assign(entry_start_form: form)}
    end
  end

  @impl true
  def handle_event("stop_entry", %{"form" => form_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.entry_stop_form, params: form_params) do
      {:ok, _entry} ->
        {:noreply,
         socket
         |> put_flash(:info, "Entry stopped")
         |> assign_bucket(socket.assigns.bucket)
         |> assign_current_entry()
         |> assign_entry_stop_form()
         |> assign_entry_description_form()}

      {:error, form} ->
        {:noreply,
         socket
         |> put_flash(:error, "Failed to stop entry")
         |> assign(entry_stop_form: form)}
    end
  end

  @impl true
  def handle_event("update_entry", %{"form" => form_params}, socket) do
    case dbg(AshPhoenix.Form.submit(socket.assigns.entry_description_form, params: form_params)) do
      {:ok, entry} ->
        {:noreply,
         socket
         |> assign_current_entry(entry)
         |> assign_entry_description_form()}

      {:error, form} ->
        {:noreply,
         socket
         |> put_flash(:error, "Failed to update entry description")
         |> assign(entry_description_form: form)}
    end
  end

  @impl true
  def handle_event("stop_entry", %{}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.entry_stop_form) do
      {:ok, _entry} ->
        {:noreply,
         socket
         |> put_flash(:info, "Entry stopped")
         |> assign_bucket(socket.assigns.bucket)
         |> assign_current_entry()
         |> assign_entry_stop_form()}

      {:error, form} ->
        {:noreply,
         socket
         |> put_flash(:error, "Failed to stop entry")
         |> assign(entry_stop_form: form)}
    end
  end
end
