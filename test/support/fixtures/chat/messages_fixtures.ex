defmodule Felixir.Chat.MessagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Felixir.Chat.Messages` context.
  """

  @doc """
  Generate a message.
  """
  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(%{
        content: "some content"
      })
      |> Felixir.Chat.Messages.create_message()

    message
  end
end
