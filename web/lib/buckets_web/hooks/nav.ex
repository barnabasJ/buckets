defmodule BucketsWeb.Hooks.Nav do
  import Phoenix.LiveView
  import Phoenix.Component

  @doc """
    Set the url to be able to use to to determine if the link is active.
  """
  def on_mount(:default, _params, _session, socket) do
    {:cont,
     socket
     |> attach_hook(:url, :handle_params, &assign_url/3)}
  end

  defp assign_url(_params, url, socket) do
    {:cont, socket |> assign(url: url)}
  end
end
