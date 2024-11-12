defmodule Felixir.Chat.Room do
  use Ecto.Schema
  import Ecto.Changeset
  alias Felixir.Auth.User
  schema "rooms" do
    field :name, :string
    field :description, :string
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name, :description, :user_id])
    |> validate_required([:name, :description, :user_id])
    |> unique_constraint(:name)
    |> validate_length(:name, min: 8,max: 30)
    |> validate_length(:description, min: 8,max: 30)
  end
end
