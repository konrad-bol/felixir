defmodule Felixir.Chat.MessageFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Felixir.Chat.Message` context.
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
      |> Felixir.Chat.Message.create_message()

    message
  end
end
