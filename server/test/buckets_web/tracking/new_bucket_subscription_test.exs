defmodule BucketsWeb.Tracking.NewBucketSubscriptionTest do
  use BucketsWeb.SubscriptionCase


  @ubscription """
  subscription {
    newBucket {
      id
      name
    }
  }
  """

  test "new buckets can be subcribed to", %{socket: socket} do
    ref = push_doc socket, @ubscription

    assert_reply ref, :ok, %{subscriptionId: subscription_id}
  end
end
