defmodule FelixirWeb.Plugs.PopulateAuth do
  import Plug.Conn
  alias Felixir.Auth
  alias Felixir.Auth.User

  def init(_params) do
  end

  def call(conn, _params) do
    user_id = Plug.Conn.get_session(conn, :current_user_id)
      if user_id do
        Auth.get_user!(user_id)
        |> case do
          %User{} ->
            conn
            |> assign(:user_signed_in?, true)
            |> assign(:current_user, Auth.get_user!(user_id))

          _ ->
            conn
            |> assign(:user_signed_in?, false)
            |> assign(:current_user, nil)
        end
      else
        conn
        |> assign(:user_signed_in?, false)
        |> assign(:current_user, nil)
      end
  end
end
