defmodule SWAPIWeb.Util do
  alias SWAPIWeb.Endpoint

  def append_query(conn, query_string) do
    Endpoint.url()
    |> URI.parse()
    |> URI.append_path(conn.request_path)
    |> URI.append_query(conn.query_string)
    |> URI.append_query(query_string)
    |> URI.to_string()
  end
end
