defmodule BucketsWeb.Form.MultiSelect do
  @moduledoc """
  inspired by https://fly.io/phoenix-files/liveview-multi-select/
  """
  use BucketsWeb, :live_component

  alias Phoenix.LiveView.JS

  def render(assigns) do
    ~H"""
    <div
      class="relative flex w-full justify-center text-sm leading-6 text-zinc-600"
      id={"multi-select-container-#{@id}"}
      phx-hook="MultiSelect"
    >
      <button
        class="relative flex h-10 w-full w-full items-center space-x-1 rounded rounded-lg border border-zinc-300 py-1 pr-10 pl-1 text-zinc-900 focus:border-zinc-400 focus:ring-0 focus:ring-0 sm:text-sm sm:leading-6"
        id={"selected-options-container-#{@id}"}
        aria-controls={"options-container-#{@id}"}
        phx-click={toggle_dropdown(@id)}
      >
        <div :if={length(@selected_options) == 0} class="ml-2 text-gray-400">Select...</div>
        <%= for option <- @selected_options do %>
          <div
            id={"option_#{option.label}"}
            class="align-center flex items-center rounded-lg bg-purple-500 px-2 text-center text-white shadow-lg dark:bg-sky-500"
          >
            <div>
              <%= option.label %>
            </div>
          </div>
        <% end %>
      </button>
      <div class="pointer-events-none absolute top-2 right-2 text-gray-500">
        <svg
          id={"#{@id}-down-icon"}
          xmlns="http://www.w3.org/2000/svg"
          class="h-5 w-5"
          viewBox="0 0 20 20"
          fill="currentColor"
        >
          <path
            fill-rule="evenodd"
            d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z"
            clip-rule="evenodd"
          />
        </svg>
        <svg
          id={"#{@id}-up-icon"}
          xmlns="http://www.w3.org/2000/svg"
          class="hidden h-5 w-5"
          viewBox="0 0 20 20"
          fill="currentColor"
        >
          <path
            fill-rule="evenodd"
            d="M14.707 12.707a1 1 0 01-1.414 0L10 9.414l-3.293 3.293a1 1 0 01-1.414-1.414l4-4a1 1 0 011.414 0l4 4a1 1 0 010 1.414z"
            clip-rule="evenodd"
          />
        </svg>
      </div>
      <.focus_wrap
        class="top-[100%] absolute z-10 hidden w-full rounded-lg bg-stone-50 p-4 shadow-2xl"
        id={"options-container-#{@id}"}
        phx-window-keydown={hide_dropdown(@id)}
        phx-key="Escape"
        phx-click-away={toggle_dropdown(@id)}
      >
        <div :for={{value, i} <- Enum.with_index(@options)} class="form-check">
          <div class="form-check-label inline-block flex text-gray-800">
            <.input
              id={"#{@id}-option-#{i}"}
              type="checkbox"
              name={value.label}
              phx-change="checked"
              phx-target={@myself}
              value={value.selected}
              class="form-check-input appearance-none h-4 w-4 border border-gray-300 rounded-sm bg-white checked:bg-blue-600 checked:border-blue-600 focus:outline-none transition duration-200 mt-1 align-top bg-no-repeat bg-center bg-contain float-left mr-2 cursor-pointer"
            />
            <label class="ml-2" for={"#{@id}-option-#{i}"}>
              <%= value.label %>
            </label>
          </div>
        </div>
      </.focus_wrap>
    </div>
    """
  end

  def update(assigns, socket) do
    %{options: options, field: field, selected: selected, id: id} = assigns

    socket =
      socket
      |> assign(:id, id)
      |> assign(:selected_options, dbg(filter_selected_options(options)))
      |> assign(:options, options)
      |> assign(:field, field)
      |> assign(:selected, selected)

    {:ok, socket}
  end

  def handle_event("checked", %{"_target" => [target]}, socket) do
    updated_options =
      Enum.map(socket.assigns.options, fn opt ->
        if opt.id == target do
          %{opt | selected: not opt.selected}
        else
          opt
        end
      end)

    socket.assigns.selected.(updated_options)

    {:noreply, socket}
  end

  defp hide_dropdown(js \\ %JS{}, id) do
    js
    |> JS.hide(to: "##{id}-up-icon")
    |> JS.hide(to: "#options-container-#{id}")
    |> JS.show(to: "##{id}-down-icon")
    |> JS.dispatch("multi-select-toggle", detail: %{"id" => id})
  end

  defp toggle_dropdown(js \\ %JS{}, id) do
    js
    |> JS.toggle(to: "##{id}-up-icon")
    |> JS.toggle(to: "#options-container-#{id}")
    |> JS.toggle(to: "##{id}-down-icon")
    |> JS.dispatch("multi-select-toggle", detail: %{"id" => id})
  end

  defp filter_selected_options(options) do
    Enum.filter(options, fn opt -> opt.selected == true or opt.selected == "true" end)
  end
end
