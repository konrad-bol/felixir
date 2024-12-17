defmodule Felixir.Auth.User do

  use Ecto.Schema
  import Ecto.Changeset
  alias Felixir.Auth.User
  alias Felixir.Chat.Room
  alias Felixir.Chat.Message.Message

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string
    field :email, :string

    has_many :rooms, Room
    has_many :messages, Message
    timestamps(type: :utc_datetime)
  end
  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :username, :password])
    |> validate_required([:name, :email, :username, :password])
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> update_change(:email, &String.downcase/1)
    |> update_change(:username, &String.downcase/1)
    |> validate_length(:password, min: 8,max: 30)
    |> validate_length(:name, min: 4,max: 30)
    |> validate_length(:username, min: 4,max: 30)
    |> hash_password()
  end
  def login_changeset(attrs) do
    %User{}
    |> cast(attrs, [:username, :password])
    |> validate_required([:username,:password])
    |> update_change(:username, &String.downcase/1)
  end
  defp hash_password(%Ecto.Changeset{} = changeset) do
    case changeset do
       %Ecto.Changeset{valid?: true, changes: %{password: password}}->
        new_changeset = put_change(changeset,:password,Argon2.hash_pwd_salt(password))
        _ ->
          changeset
    end
  end
end
