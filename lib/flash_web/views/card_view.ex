defmodule FlashWeb.CardView do
  use FlashWeb, :view
  alias Flash.Card

  def render("index.json", %{cards: cards}) do
    %{data: render_many(cards, __MODULE__, "card.json")}
  end

  def render("card.json", %{card: card}) do
    %{front: card.front,
      back: card.back,
      times_seen: card.times_seen,
      success_rate: Card.success_rate(card),
      is_due: Card.is_due?(card),
      next_review: Card.next_review(card)
    }
  end
end
