defmodule FelixirWeb.Schema.Resolvers.MessageResolver do
  alias Felixir.Auth
  alias Felixir.Chat
  alias Felixir.Chat.Room
  alias Felixir.Chat.Message
  alias FelixirWeb.Utilis
  alias FelixirWeb.Constants

  def get_all_message(_, %{input: input}, %{context: context}) do
    {:ok, Message.list_messages(input.room_id, context.current_user.id)}
  end

  def delete_message(_, %{input: input}, %{context: context}) do
    Message.delete_message_by_id(input.room_id, context.current_user.id, input.message_id)
    |> case do
      {1, _} -> {:ok, true}
      {0, _} -> {:error, Constants.not_found()}
      _ -> {:error, Constants.internal_server_error()}
    end
  end

  def create_message(_, %{input: input}, %{context: context}) do
    case Chat.get_room(input.room_id) do
      %Room{} ->
        Map.merge(input, %{user_id: context.current_user.id, room_id: input.room_id})
        |> Message.create_message()
        |> case do
          {:ok, _} ->
            {:ok, true}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:error, Utilis.format_chageset_errors(changeset)}

          _ ->
            {:error, Constants.not_found()}
        end

      _ ->
        {:error, Constants.not_found()}
    end
  end
end
