defmodule SWAPI.Starships do
  @moduledoc """
  The Starships context.
  """

  alias SWAPI.Repo
  alias SWAPI.Schemas.Starship
  alias SWAPI.Schemas.Transport

  import Ecto.Query, warn: false
  import SWAPI.Util

  def preload_all(starship) do
    Repo.preload(starship, [:transport, :films, :pilots])
  end

  @doc """
  Returns the list of starships.

  ## Examples

      iex> list_starships()
      [%Starship{}, ...]

  """
  def list_starships do
    Starship
    |> Repo.all()
    |> preload_all()
  end

  def list_starships(params) do
    with {:ok, {starships, meta}} <- paginate(Starship, params) do
      {:ok, {preload_all(starships), meta}}
    end
  end

  def search_starships(terms, params) do
    query =
      Starship
      |> join(:left, [s], t in Transport, on: s.id == t.id)

    starships =
      Enum.reduce(terms, query, fn term, query ->
        query
        |> where([s, t], like(t.name, ^"%#{term}%") or like(t.model, ^"%#{term}%"))
      end)

    with {:ok, {starships, meta}} <- paginate(starships, params) do
      {:ok, {preload_all(starships), meta}}
    end
  end

  @doc """
  Gets a single starship.

  Raises `Ecto.NoResultsError` if the Starship does not exist.

  ## Examples

      iex> get_starship!(123)
      %Starship{}

      iex> get_starship!(456)
      ** (Ecto.NoResultsError)

  """
  def get_starship!(id) do
    Starship
    |> Repo.get!(id)
    |> preload_all()
  end

  def get_starship(id) do
    case Repo.get(Starship, id) do
      %Starship{} = starship ->
        {:ok, preload_all(starship)}

      _ ->
        {:error, :not_found}
    end
  end

  @doc """
  Creates a starship.

  ## Examples

      iex> create_starship(%{field: value})
      {:ok, %Starship{}}

      iex> create_starship(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_starship(attrs \\ %{}) do
    %Starship{}
    |> Starship.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a starship.

  ## Examples

      iex> update_starship(starship, %{field: new_value})
      {:ok, %Starship{}}

      iex> update_starship(starship, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_starship(%Starship{} = starship, attrs) do
    starship
    |> Starship.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a starship.

  ## Examples

      iex> delete_starship(starship)
      {:ok, %Starship{}}

      iex> delete_starship(starship)
      {:error, %Ecto.Changeset{}}

  """
  def delete_starship(%Starship{} = starship) do
    Repo.delete(starship)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking starship changes.

  ## Examples

      iex> change_starship(starship)
      %Ecto.Changeset{data: %Starship{}}

  """
  def change_starship(%Starship{} = starship, attrs \\ %{}) do
    Starship.changeset(starship, attrs)
  end
end
