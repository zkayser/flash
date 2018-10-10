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

  @spec schedule_next_review(Card.t()) :: NaiveDateTime.t()
  def schedule_next_review(%Card{streak: 0} = card), do: card.next_review
  def schedule_next_review(%Card{streak: streak}) do
    now = NaiveDateTime.utc_now()
    case streak do
      1 -> NaiveDateTime.add(now, 60 * 60 * 8, :seconds)
      2 -> NaiveDateTime.add(now, 60 * 60 * 24, :seconds)
      3 -> NaiveDateTime.add(now, 60 * 60 * 24 * 2, :seconds)
      4 -> NaiveDateTime.add(now, 60 * 60 * 24 * 4, :seconds)
      5 -> NaiveDateTime.add(now, 60 * 60 * 24 * 8, :seconds)
      6 -> NaiveDateTime.add(now, 60 * 60 * 24 * 16, :seconds)
      _ -> NaiveDateTime.add(now, 60 * 60 * 24 * 32, :seconds)
    end
  end
end
