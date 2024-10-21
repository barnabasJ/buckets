defmodule BucketsWeb.Tracking.Bucket.Overview.Components do
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
        <h3 class="font-bold">Entries</h3>
        <ul>
          <%= for entry <- @bucket.finished_entries do %>
            <li>
              <span><%= Cldr.DateTime.to_string!(entry.from, format: :short) %></span>
              <%= if not is_nil(entry.to) do %>
                - <span><%= Cldr.DateTime.to_string!(entry.to, format: :short) %></span>:
              <% else %>
                :
              <% end %>
              <span><%= Conversion.minutes_to_string(entry.duration) %></span>
            </li>
          <% end %>
        </ul>
      </div>
    </div>
    """
  end
end
