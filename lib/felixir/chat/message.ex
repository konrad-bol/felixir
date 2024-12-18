defmodule Felixir.Chat.Message do
  @moduledoc """
  The Chat.Message context.
  """

  import Ecto.Query, warn: false
  alias Felixir.Repo

  alias Felixir.Chat.Message.Message

  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def list_messages(room_id, cursor \\ nil) do
    limit = 10

    case cursor do
      nil ->
        Repo.all(
          from(m in Message, where: m.room_id == ^room_id,
          limit: ^limit,
          preload: [:user, :room])
        )

      cursor ->
        Repo.all(
          from(m in Message,
            where: m.room_id == ^room_id and m.id > ^cursor,
            limit: ^limit,
            preload: [:user, :room]
          )
        )
    end
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(id), do: Repo.get!(Message, id)

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{data: %Message{}}

  """
  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end

  def delete_message_by_id(room_id, user_id, message_id) do
    Repo.delete_all(
      from(r in Message,
        where: r.room_id == ^room_id and r.user_id == ^user_id and r.id == ^message_id
      )
    )
  end
end
