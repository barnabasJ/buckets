defmodule BucketsWeb.Form.MultiSelect do
  use BucketsWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="flex justify-center relative">
      <div
        class="border border-gray-200 dark:border-gray-700 w-96 h-12 pb-2 m-2 w-96 flex relative"
        id={"selected-options-container-#{@id}"}
        phx-click={
          JS.toggle(to: "##{@id}-up-icon")
          |> JS.toggle(to: "#options-container-#{@id}")
          |> JS.toggle(to: "##{@id}-down-icon")
          |> JS.toggle(to: "#options-container-#{@id}")
        }
      >
        <%= for option <- @selected_options do %>
          <div
            id={"option_#{option.label}"}
            class="bg-purple-500 shadow-lg rounded-lg mt-2 ml-1 text-white dark:bg-sky-500 inline-block pl-2 pr-2 text-center"
          >
            <%= option.label %>
          </div>
        <% end %>
        <div class="absolute right-0">
          <svg
            id={"#{@id}-down-icon"}
            xmlns="http://www.w3.org/2000/svg"
            class="h-5 w-5 absolute right-0 top-3"
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
            class="h-5 w-5  absolute right-0 top-3 hidden"
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
      </div>
      <div
        class="hidden w-96 mt-4 p-4 ml-2 mt-16 absolute z-10 bg-stone-50 shadow-2xl rounded-lg top-[100%]"
        id={"options-container-#{@id}"}
      >
        <div :for={value <- @options} class="form-check">
          <div class="form-check-label inline-block text-gray-800 flex">
            <.input
              id={"#{@id}-#{value.label}"}
              type="checkbox"
              name={value.label}
              phx-change="checked"
              phx-target={@myself}
              value={value.selected}
              class="form-check-input appearance-none h-4 w-4 border border-gray-300 rounded-sm bg-white checked:bg-blue-600 checked:border-blue-600 focus:outline-none transition duration-200 mt-1 align-top bg-no-repeat bg-center bg-contain float-left mr-2 cursor-pointer"
            />
            <label class="ml-2" for={"#{@id}-#{value.label}"}>
              <%= value.label %>
            </label>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def update(assigns, socket) do
    %{options: options, form: form, selected: selected, id: id} = assigns
    dbg(options)

    socket =
      socket
      |> assign(:id, id)
      |> assign(:selected_options, dbg(filter_selected_options(options)))
      |> assign(:options, options)
      |> assign(:form, form)
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

  defp filter_selected_options(options) do
    Enum.filter(options, fn opt -> opt.selected == true or opt.selected == "true" end)
  end
end
