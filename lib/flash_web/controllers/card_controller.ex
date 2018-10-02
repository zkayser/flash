defmodule FlashWeb.CardController do
  use FlashWeb, :controller

  action_fallback FlashWeb.FallbackController

  def index(conn, %{"deck_id" => deck_id}) do
    cards = Flash.list_cards(deck_id)
    render(conn, "index.json", %{cards: cards})
  end

  def show(conn, %{"id" => id}) do
    with %Flash.Card{} = card <- Flash.get_card(id) do
      render(conn, "card.json", %{card: card})
    end
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
