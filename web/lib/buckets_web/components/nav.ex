defmodule BucketsWeb.Nav do
  use BucketsWeb, :html

  attr :navigate, :string, required: true
  attr :url, :string, required: true
  attr :exact, :boolean, default: false
  attr :rest, :global, include: ~w(a)

  slot :inner_block,
    required: true,
    doc: """
    The content rendered inside of the `a` tag.
    """

  def nav_link(assigns) do
    assigns =
      assigns
      |> assign(
        :active,
        if assigns.exact do
          assigns.navigate == assigns.url
        else
          String.starts_with?(URI.parse(assigns.url).path, assigns.navigate)
        end
      )

    ~H"""
    <.link
      navigate={@navigate}
      class={create_classes(["hover:text-zinc-700", {"font-bold", @active}])}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </.link>
    """
  end

  defp create_classes(classes) do
    classes
    |> List.wrap()
    |> Enum.filter(fn
      {_class, condition} -> condition
      _ -> true
    end)
    |> Enum.map(fn
      {class, _} -> class
      class -> class
    end)
  end
end
