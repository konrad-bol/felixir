defmodule FelixirWeb.AuthJSON do
  def acknowledge(%{success: success, message: message}) do
    %{
      success: success,
      message: message
    }
  end

  def error(%{success: success, error: error}) do
    %{
      success: success,
      error: error
    }
  end

  def getme(%{current_user: current_user}) do
    %{
      success: true,
      data: %{
        name: current_user.name,
        username: current_user.username,
        email: current_user.email,
        inserted_at: current_user.inserted_at
      }
    }
  end
end
