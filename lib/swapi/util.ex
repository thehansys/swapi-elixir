defmodule SWAPI.Util do
  @moduledoc """
  Utility functions
  """

  @type page_info() :: %{
          count: non_neg_integer,
          next: non_neg_integer | nil,
          previous: non_neg_integer | nil
        }

  @doc """
  Queries the given Ecto queryable with pagination.
  """
  @spec paginate(Ecto.Queryable.t(), map()) :: {:ok, {list, page_info}} | {:error, atom}
  def paginate(query, params) do
    with {:ok, page} <- get_page_number(params),
         {list, meta} <- Flop.validate_and_run!(query, %Flop{page: page}) do
      {:ok,
       {list, %{count: meta.total_count, next: meta.next_page, previous: meta.previous_page}}}
    end
  end

  defp get_page_number(%{"page" => page}) when is_binary(page) do
    case Integer.parse(page) do
      :error -> {:error, :bad_request}
      {page, _} -> {:ok, page}
    end
  end

  defp get_page_number(_params), do: {:ok, 1}
end
