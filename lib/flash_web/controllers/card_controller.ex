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

  def create(conn, %{"deck_id" => _} = params) do
    with {:ok, %Flash.Card{} = card} <- Flash.create_card(params) do
      conn
      |> put_status(:created)
      |> render("card.json", %{card: card})
    end
  end

  def update(conn, %{"deck_id" => _, "id" => id, "passed" => passed}) do
    with %Flash.Card{} = card <- Flash.get_card(id),
          {:ok, %Flash.Card{} = card} <-
            card
            |> Flash.Card.review_passed?(passed)
            |> Flash.Repo.update() do
      render(conn, "card.json", %{card: card})
    end
  end

  def update(conn, %{"deck_id" => _, "id" => id} = params) do
    with %Flash.Card{} = card <- Flash.get_card(id),
      {:ok, %Flash.Card{} = card} <- Flash.update_card(card, params)
      do
        render(conn, "card.json", %{card: card})
      end
  end

  def delete(conn, _params) do
    json conn, %{}
  end
end
