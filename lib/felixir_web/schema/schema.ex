defmodule FelixirWeb.Schema do
  use Absinthe.Schema
  import_types(FelixirWeb.Schema.Types)

  alias FelixirWeb.Schema.Resolvers

  query do
    @desc "greet"
    field :hello, :string do
      resolve(fn _, _, _ -> "words" end)
    end

    @desc "get all users"
    field :users, list_of(:user_type) do
      resolve(&Resolvers.UserResolver.get_all_users/3)
    end

    @desc "get me"
    field :get_me, :user_type do
      resolve(&Resolvers.UserResolver.get_me/3)
    end

    @desc "get all rooms"
    field :rooms, list_of(:room_type) do
      resolve(&Resolvers.RoomResolver.get_all_rooms/3)
    end
    @desc "get all messages"
    field :messages, list_of(:message_type) do
      arg(:input, non_null(:list_message_type))
      resolve(&Resolvers.MessageResolver.get_all_message/3)
    end

  end

  mutation do
    @desc "register new user"
    field :register_user, :boolean do
      arg(:input, non_null(:registration_input_type))
      resolve(&Resolvers.UserResolver.register_user/3)
    end

    @desc "create new user"
    field :create_room, :boolean do
      arg(:input, non_null(:room_input_type))
      resolve(&Resolvers.RoomResolver.create_room/3)
    end
    field :create_messages, :boolean do
      arg(:input, non_null(:message_input_type))
      resolve(&Resolvers.MessageResolver.create_message/3)
    end

    @desc "delete room"
    field :delete_room, :boolean do
      arg(:input, non_null(:delete_room_input_type))
      resolve(&Resolvers.RoomResolver.delete_room/3)
    end
    @desc "delete room"
    field :delete_message, :boolean do
      arg(:input, non_null(:delete_message_input_type))
      resolve(&Resolvers.MessageResolver.delete_message/3)
    end
  end
end
