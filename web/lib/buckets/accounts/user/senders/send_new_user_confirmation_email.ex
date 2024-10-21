defmodule Buckets.Accounts.User.Senders.SendNewUserConfirmationEmail do
  @moduledoc """
  Sends a password reset email
  """

  use AshAuthentication.Sender
  use BucketsWeb, :verified_routes

  @impl true
  def send(_user, token, _) do
    # Example of how you might send this email
    # Buckets.Accounts.Emails.send_password_reset_email(
    #   user,
    #   token
    # )

    IO.puts("""
    Click this link to confirm your email:

    #{url(~p"/auth/user/confirm_new_user?#{[token: token]}")}
    """)
  end
end
