defmodule BucketsWeb.Tracking.Bucket.Overview.Components do
  alias Buckets.Tracking.Bucket
  use BucketsWeb, :html

  alias BucketsWeb.CoreComponents

  def bucket(assigns) do
    assigns =
      assigns
      |> assign(
        :current_duration,
        Conversion.minutes_to_string(assigns.bucket.current_duration)
      )
      |> assign(
        :duration,
        Conversion.minutes_to_string(assigns.bucket.current_duration)
      )

    ~H"""
    <div>
      <.link href={~p"/tracking/#{@bucket.id}"}>
        <h2 class="text-lg font-bold flex items-center">
          Name: <%= @bucket.name %>

          <CoreComponents.icon name="hero-arrow-top-right-on-square" class="ml-2 h-5 w-5" />
        </h2>
      </.link>
      <%= if @duration != "" do %>
        <p>Total time spent: <%= Conversion.minutes_to_string(@bucket.current_duration) %></p>
      <% else %>
        <p>Total time spent: 0 minutes</p>
      <% end %>
      <%= if @current_duration != "" do %>
        <p>Time spent today: <%= Conversion.minutes_to_string(@bucket.current_duration) %></p>
      <% end %>

      <div class="mt-2">
        <.entries entries={@bucket.finished_entries} />
      </div>
    </div>
    """
  end

  attr :bucket, Bucket, required: true
  attr :form, :any, required: true

  def new_entry(assigns) do
    ~H"""
    <.entry_start_form bucket={@bucket} form={@form} />
    """
  end

  attr :bucket, Bucket, required: true
  attr :form, :any, required: true

  def entry_start_form(assigns) do
    ~H"""
    <.form
      for={@form}
      phx-submit="start_entry"
      id={"#{@bucket.id}-entry-start-form"}
      class="flex items-center"
    >
      <.input
        id={"#{@bucket.id}-entry-start-form-bucket-id"}
        field={@form[:bucket_id]}
        value={@bucket.id}
        type="hidden"
      />
      <.input
        id={"#{@bucket.id}-entry-start-form-description"}
        hide_label
        label="Description"
        field={@form[:description]}
        placeholder="Description"
        type="text"
        class="w-1/3"
      />
      <.button class="ml-2">
        <.icon name="hero-play" class="h-5 w-5" />
      </.button>
    </.form>
    """
  end

  attr :bucket, Bucket, required: true
  attr :description_form, :any, required: true
  attr :stop_form, :any, required: true

  def current_entry(assigns) do
    ~H"""
    <div class="flex space-x-2 items-center">
      <.entry_description_form bucket={@bucket} form={@description_form} />
      <.entry_stop_form bucket={@bucket} form={@stop_form} />
    </div>
    """
  end

  attr :bucket, Bucket, required: true
  attr :form, :any, required: true

  def entry_stop_form(assigns) do
    ~H"""
    <.form for={@form} phx-submit="stop_entry" id={"#{@bucket.id}-entry-stop-form"}>
      <.button class="ml-2">
        <.icon name="hero-stop" class="h-5 w-5" />
      </.button>
    </.form>
    """
  end

  attr :bucket, Bucket, required: true
  attr :form, :any, required: true

  def entry_description_form(assigns) do
    ~H"""
    <.form for={@form} phx-change="update_entry" id={"#{@bucket.id}-entry-description-form"}>
      <.input
        id={"#{@bucket.id}-entry-description-form-input"}
        hide_label
        label="Description"
        placeholder="Description"
        field={dbg(@form[:description])}
        phx-debounce="500"
        type="text"
        class="w-1/3"
      />
    </.form>
    """
  end

  attr :entries, :any, required: true

  def entries(assigns) do
    assigns =
      assigns
      |> assign(:entries_by_date, entries_by_date(assigns.entries))

    ~H"""
    <div>
      <h3 class="font-bold">Entries</h3>
      <ul>
        <%= for {date, entries} <- @entries_by_date do %>
          <li>
            <.entries_for_date date={date} entries={entries} />
          </li>
        <% end %>
      </ul>
    </div>
    """
  end

  attr :date, :any, required: true
  attr :entries, :any, required: true

  defp entries_for_date(assigns) do
    ~H"""
    <div>
      <h3>
        <%= Cldr.DateTime.to_string!(@date, format: :short) %>
      </h3>
      <ul>
        <%= for entry <- @entries do %>
          <li>
            <.entry entry={entry} />
          </li>
        <% end %>
      </ul>
    </div>
    """
  end

  attr :entry, :any

  def entry(assigns) do
    assigns =
      assigns
      |> assign(:from, DateTime.to_time(assigns.entry.from))
      |> assign(:to, DateTime.to_time(assigns.entry.to))

    ~H"""
    <div>
      <span><%= @entry.description %></span>
      / <span><%= Cldr.Time.to_string!(@from, format: :short) %></span>
      <%= if not is_nil(@entry.to) do %>
        - <span><%= Cldr.Time.to_string!(@to, format: :short) %></span>:
      <% else %>
        :
      <% end %>
      <span><%= Conversion.minutes_to_string(@entry.duration) %></span>
    </div>
    """
  end

  defp entries_by_date(entries) do
    entries
    |> Enum.group_by(&DateTime.to_date(&1.from))
    |> Stream.map(fn {date, entries} ->
      {date, Enum.sort_by(entries, & &1.from, DateTime)}
    end)
    |> Enum.sort_by(fn {date, _} -> date end, Date)
  end
end
