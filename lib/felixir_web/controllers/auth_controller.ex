defmodule FelixirWeb.AuthController do
  use FelixirWeb, :controller
  import Plug.Conn
  alias FelixirWeb.Constants
  alias Felixir.Auth
  alias FelixirWeb.Utilis
  alias Felixir.Auth.User

  plug(:dont_exploit_me when action in [:login, :register])
  plug(:protect_me when action in [:logout, :getme])

  def register(conn, params) do

    Auth.create_user(params)
    |> case do
      {:ok, _} ->
        render(conn, "acknowledge.json", %{success: true, message: "User Registered"})

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "error.json", %{
          success: false,
          error: Utilis.format_chageset_errors(changeset)
        })

      _ ->
        {:error, Constants.internal_server_error()}
    end
  end

  def login(conn, params) do
    User.login_changeset(params)
    |> case do
      %Ecto.Changeset{valid?: true, changes: %{password: password, username: username}} ->
        case user = Auth.get_by_username(username) do
          %User{} ->
            if Argon2.verify_pass(password, user.password) do
              conn
              |> put_status(:created)
              |> put_session(:current_user_id, user.id)
              |> render("acknowledge.json", %{success: true, message: "Logged in"})
            else
              render(conn, "error.json", %{
                success: false,
                error: Constants.not_authorized()
              })
            end

          _ ->
            render(conn, "error.json", %{
              success: false,
              error: Constants.not_authorized()
            })
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "error.json", %{
          success: false,
          error: Utilis.format_chageset_errors(changeset)
        })

      _ ->
        {:error, Constants.internal_server_error()}
    end
  end

  def getme(conn, params) do
    conn
    |> render("getme.json", %{current_user: conn.assigns.current_user})
  end

  def logout(conn, params) do
    conn
    |> Plug.Conn.clear_session()
    |> render("acknowledge.json", %{success: true, message: "Logged out"})
  end

  defp dont_exploit_me(conn, _params) do
    if conn.assigns.user_signed_in? do
      send_resp(conn, 401, Constants.not_authorized())

      conn
      |> halt()
    else
      conn
    end
  end

  defp protect_me(conn, _params) do
    if conn.assigns.user_signed_in? do
      conn
    else
      send_resp(conn, 401, Constants.not_authorized())

      conn
      |> halt()
    end
  end
end
