defmodule LivemanApi do
  @moduledoc """
  API Wrapper for Liveman
  """

  @timeout 30_000

  def get(base_url, url, query \\ %{}, headers \\ []) do
    base_url
    |> client()
    |> Tesla.get(url, query: Map.to_list(query), headers: headers)
    |> handle_response()
  end

  def post(base_url, url, body \\ %{}, headers \\ []) do
    base_url
    |> client()
    |> Tesla.post(url, body, headers: headers)
    |> handle_response()
  end

  defp client(base_url) do
    middleware = [
      {Tesla.Middleware.BaseUrl, base_url},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"Content-Type", "application/json"}]},
      {Tesla.Middleware.Timeout, [timeout: @timeout]}
    ]

    adapter = {Tesla.Adapter.Hackney, [recv_timeout: @timeout]}

    Tesla.client(middleware, adapter)
  end

  defp handle_response({:ok, %{status: status, body: body}}) when status in 200..299,
    do: {:ok, body}

  defp handle_response({:ok, %{status: status, body: body}}),
    do: {:error, %{status: status, body: body}}

  defp handle_response({:error, reason}), do: {:error, reason}
end
