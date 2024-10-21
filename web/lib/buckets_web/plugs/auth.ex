defmodule BucketsWeb.Plugs.Auth do
  @behaviour Plug

  @otp_app :buckets

  alias AshAuthentication.{Info, Jwt, TokenResource}
  alias Plug.Conn

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, _) do
    conn
    |> Conn.get_req_header("authorization")
    |> load_user_from_bearer_token(Ash.PlugHelpers.get_tenant(conn))
    |> Enum.reduce(conn, fn %{
                              subject_name: subject_name,
                              current_subject_name: current_subject_name,
                              token_record: token_record,
                              user: user
                            },
                            conn ->
      conn
      |> Conn.assign(current_subject_name, user)
      |> maybe_assign_token_record(token_record, subject_name)
      |> Ash.PlugHelpers.set_actor(user)
    end)
  end

  def load_user_from_bearer_token(headers, tenant) when is_list(headers) do
    headers
    |> Stream.filter(&String.starts_with?(&1, "Bearer "))
    |> Stream.map(&String.replace_leading(&1, "Bearer ", ""))
    |> Enum.reduce([], fn token, acc ->
      with {:ok, %{"sub" => subject, "jti" => jti} = claims, resource}
           when not is_map_key(claims, "act") <- Jwt.verify(token, @otp_app),
           {:ok, token_record} <-
             validate_token(resource, jti),
           {:ok, user} <-
             AshAuthentication.subject_to_user(subject, resource, tenant: tenant),
           {:ok, subject_name} <- Info.authentication_subject_name(resource),
           current_subject_name <- current_subject_name(subject_name) do
        [
          %{
            subject_name: subject_name,
            current_subject_name: current_subject_name,
            token_record: token_record,
            user: user
          }
          | acc
        ]
      else
        _ -> acc
      end
    end)
  end

  def load_user_from_bearer_token(headers, tenant),
    do: load_user_from_bearer_token([headers], tenant)

  defp validate_token(resource, jti) do
    if Info.authentication_tokens_require_token_presence_for_authentication?(resource) do
      with {:ok, token_resource} <-
             Info.authentication_tokens_token_resource(resource),
           {:ok, [token_record]} <-
             TokenResource.Actions.get_token(token_resource, %{
               "jti" => jti,
               "purpose" => "user"
             }) do
        {:ok, token_record}
      else
        _ -> :error
      end
    else
      {:ok, nil}
    end
  end

  defp maybe_assign_token_record(conn, _token_record, subject_name) when is_nil(subject_name) do
    conn
  end

  defp maybe_assign_token_record(conn, token_record, subject_name) do
    conn
    |> Conn.assign(
      current_subject_token_record_name(subject_name),
      token_record
    )
  end

  # Dyanamically generated atoms are generally frowned upon, but in this case
  # the `subject_name` is a statically configured atom, so should be fine.
  # sobelow_skip ["DOS.StringToAtom"]
  defp current_subject_name(subject_name) when is_atom(subject_name),
    do: String.to_atom("current_#{subject_name}")

  # sobelow_skip ["DOS.StringToAtom"]
  defp current_subject_token_record_name(subject_name) when is_atom(subject_name),
    do: String.to_atom("current_#{subject_name}_token_record")
end
