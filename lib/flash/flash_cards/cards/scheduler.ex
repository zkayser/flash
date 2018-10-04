defmodule Flash.Card.Scheduler do
  alias Flash.Card

  @moduledoc """
  `Flash.Card.Scheduler` is solely responsible for
  scheduling the next review for a card after a review.

  It operates under the principle that a card should be
  rescheduled for immedate review if a user fails to
  recall the information on the card during a review.

  If the user accurately recalls the information on the
  card, it will schedule the card at increasingly longer
  intervals in the future, based off of a consecutive number
  of correctly answered reviews.
  """

  @spec schedule_next_review(Card.t(), boolean()) :: NaiveDateTime.t()
  def schedule_next_review(%Card{} = card, false), do: card.next_review
  def schedule_next_review(%Card{} = card, true) do
    card.next_review
  end
end
