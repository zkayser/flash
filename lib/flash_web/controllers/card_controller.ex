defmodule FlashWeb.CardController do
  use FlashWeb, :controller

  def index(conn, %{"deck_id" => deck_id}) do
    cards = Flash.list_cards(deck_id)
    render(conn, "index.json", %{cards: cards})
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
end
