defmodule BucketsWeb.SubscriptionCase do
  @moduledoc """
  This module defines the test case to be used by
  subscriptions tests.
  """
  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with channels
      use BucketsWeb.ChannelCase

      use Absinthe.Phoenix.SubscriptionTest,
        schema: BucketsWeb.Schema

      setup do
        {:ok, socket} =
          Phoenix.ChannelTest.connect(BucketsWeb.UserSocket, %{})

        {:ok, socket} =
          Absinthe.Phoenix.SubscriptionTest.join_absinthe(socket)

        {:ok, socket: socket}
      end

      import unquote(__MODULE__), only: [menu_item: 1]
    end
  end
end
