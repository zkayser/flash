defmodule FlashWeb.CardView do
  use FlashWeb, :view
  alias Flash.Card

  def render("index.json", %{cards: cards}) do
    %{data: render_many(cards, __MODULE__, "card.json")}
  end

  def render("card.json", %{card: card}) do
    %{
      front: card.front,
      back: card.back,
      times_seen: card.times_seen,
      next_review: card.next_review,
      success_rate: Card.success_rate(card),
      is_due: Card.is_due?(card),
      next_review_string: Card.next_review(card)
    }
  end

  def render("deleted.json", _data) do
    %{message: "Card deleted successfully"}
  end
end
