defmodule FelixirWeb.AuthView do
  use FelixirWeb, :view

  def render("acknowledge.json", %{message: message}) do
    %{success: true,message: message}

  end
end
