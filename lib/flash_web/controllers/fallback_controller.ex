defmodule FlashWeb.FallbackController do
  use Phoenix.Controller

  def call(conn, {:error, :not_found, :card}) do
    conn
    |> put_status(:not_found)
    |> render(FlashWeb.ErrorView, "404.json", %{message: "Card not found"})
  end

  def call(conn, {:error, errors}) when is_list(errors) do
    conn
    |> put_status(:bad_request)
    |> render(FlashWeb.ErrorView, "400.json", %{message: errors})
  end
end
