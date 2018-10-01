defmodule FlashWeb.DeckController do
  use FlashWeb, :controller

  def index(conn, %{"topic_id" => topic_id}) do
    case Flash.Repo.get(Flash.Topic, topic_id) do
      nil -> render_error(conn, :no_topic)
      _ -> render(conn, "index.json", decks: Flash.list_decks(topic_id))
    end
  end

  def show(conn, _params) do
    json conn, %{}
  end

  def create(conn, _params) do
    json conn, %{}
  end

  def update(conn, _params) do
    json conn, %{}
  end

  def delete(conn, _params) do
    json conn, %{}
  end

  defp render_error(conn, :no_topic) do
    conn
    |> put_status(:not_found)
    |> render("topic_missing.json")
  end
end