defmodule SWAPIWeb.FilmController do
  use SWAPIWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias SWAPI.Films

  import SWAPIWeb.Util

  action_fallback SWAPIWeb.FallbackController

  tags ["films"]

  operation :index,
    summary: "Get all the film resources",
    parameters: [
      search: [in: :query, description: "Search query", type: :string],
      page: [in: :query, description: "Page number", type: :integer]
    ],
    responses: [
      ok: {"List of films", "application/json", SWAPIWeb.Schemas.FilmList}
    ]

  def index(conn, %{"search" => query} = params) do
    query = parse_search_query(query)

    with {:ok, {films, meta}} <- Films.search_films(query, params) do
      render(conn, :index, films: films, meta: meta)
    end
  end

  def index(conn, params) do
    with {:ok, {films, meta}} <- Films.list_films(params) do
      render(conn, :index, films: films, meta: meta)
    end
  end

  operation :show,
    summary: "Get a specific film resource",
    parameters: [
      id: [in: :path, description: "Film ID", type: :integer]
    ],
    responses: [
      ok: {"A film", "application/json", SWAPIWeb.Schemas.Film}
    ]

  def show(conn, %{"id" => id}) do
    film = Films.get_film!(id)
    render(conn, :show, film: film)
  end
end
