defmodule FelixirWeb.Utilis do


  import Ecto.Changeset
  def format_chageset_errors(%Ecto.Changeset{} = changeset) do
    errors =
      traverse_errors(changeset,fn {msg, opt} ->
        Enum.reduce(opt,msg, fn {key,value}, acc ->
          String.replace(acc,"%{#{key}}",to_string(value))
        end)
      end)
      formatred_errors =
        Enum.map(errors, fn {key,value} ->
          "#{key} #{value}"
        end)
  end
end
