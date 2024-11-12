defmodule FelixirWeb.Schema.Resolvers.UserResolver do
alias Felixir.Auth
alias FelixirWeb.Utilis
alias FelixirWeb.Constants.Constants

  def get_all_users(_,arg,_) do
    {:ok,Auth.list_users()}
  end
  def register_user(_,%{input: input},_) do
    IO.inspect(input)
    Auth.create_user(input)
    |> case do
      {:ok,_} ->{:ok, true}

      {:error,%Ecto.Changeset{} =changeset} ->
        {:error,Utilis.format_chageset_errors(changeset)}

      _ -> {:error,Constants.internal_server_error}

    end
  end
  def get_me(_,_,%{context: %{current_user: current_user}}) do
    {:ok, current_user}
  end

end
