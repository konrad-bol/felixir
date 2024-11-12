defmodule Felixir.ChatFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Felixir.Chat` context.
  """

  @doc """
  Generate a unique room name.
  """
  def unique_room_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a room.
  """
  def room_fixture(attrs \\ %{}) do
    {:ok, room} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: unique_room_name()
      })
      |> Felixir.Chat.create_room()

    room
  end
end
