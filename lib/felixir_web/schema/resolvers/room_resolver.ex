defmodule FelixirWeb.Schema.Resolvers.RoomResolver do
  alias Felixir.Auth
  alias Felixir.Chat
  alias FelixirWeb.Utilis
  alias FelixirWeb.Constants

  def get_all_rooms(_, arg, _) do
    {:ok, Chat.list_rooms()}
  end

  def delete_room(_, %{input: input}, %{context: context}) do
    Chat.delete_room_by_id(input.room_id, context.current_user.id)
    |>case  do
      {1,_} ->{:ok,true}
      {0,_} -> {:error,Constants.not_found()}
      _ -> {:error, Constants.internal_server_error()}

    end

  end

  def create_room(_, %{input: input}, %{context: context}) do
    Map.merge(input, %{user_id: context.current_user.id})
    |> Chat.create_room()
    |> case do
      {:ok, _} ->
        {:ok, true}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, Utilis.format_chageset_errors(changeset)}

      _ ->
        {:error, Constants.internal_server_error()}
    end
  end
end
