defmodule Flash.Card do
  alias __MODULE__
  use Ecto.Schema
  import Ecto.{Query, Changeset}

  @moduledoc """
  This module contains a database-backed struct representing
  a flash card. The `front` represents a question while the
  `back` property marks an answer. As a flash card is seen
  over time, the reviewer of the card will accrue a success
  vs times_seen ratio that translates to a 'mastery' level.

  The `Card` module contains the algorithm for determing
  what level the reviewer is at for a given flash card.
  """

  @type t :: %Card{}

  @type mastery :: :rookie | :beginner | :amateur | :pro | :master

  schema "cards" do
    field(:front, :string, default: "")
    field(:back, :string, default: "")
    field(:successes, :integer, default: 0)
    field(:failures, :integer, default: 0)
    field(:times_seen, :integer, default: 0)
    field(:next_review, :naive_datetime, default: NaiveDateTime.utc_now())
    field(:last_review, :naive_datetime, default: NaiveDateTime.utc_now())

    belongs_to(:deck, Flash.Deck)
    timestamps()
  end

  @spec mastery(t()) :: mastery
  def mastery(%Card{} = card) do
    case {card.successes, card.times_seen} do
      {0, _} -> :rookie
      {_, seen} when seen < 5 -> :rookie
      {successes, seen} -> calculate_mastery(successes / seen, seen)
    end
  end

  @spec update(t(), true) :: Ecto.Query.t()
  def update(%Card{} = card, true) do
    from(c in Card,
      where: c.id == ^card.id,
      update: [inc: [successes: 1, times_seen: 1]]
    )
  end

  def update(%Card{} = card, false) do
    from(c in Card,
      where: c.id == ^card.id,
      update: [inc: [failures: 1, times_seen: 1]]
    )
  end

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(%Card{} = card, attrs \\ %{}) do
    card
    |> cast(attrs, [:front, :back, :deck_id])
    |> foreign_key_constraint(:deck_id)
    |> validate_required([:front, :back, :deck_id])
  end

  @spec cards_for_deck(non_neg_integer) :: Ecto.Query.t()
  def cards_for_deck(deck_id) do
    from c in Card, where: c.deck_id == ^deck_id
  end

  @spec success_rate(t()) :: integer()
  def success_rate(%Card{times_seen: 0}), do: 0
  def success_rate(%Card{} = card) do
    (card.successes / card.times_seen)
    |> Kernel.*(100)
    |> Float.round()
    |> trunc()
  end

  @spec is_due?(t()) :: boolean()
  def is_due?(%Card{next_review: next}) do
    case NaiveDateTime.compare(NaiveDateTime.utc_now, next) do
      :gt -> true
      _ -> false
    end
  end

  @spec next_review(t()) :: String.t()
  def next_review(%Card{next_review: next} = card) do
    if is_due?(card) do
      "Now"
    else
      case NaiveDateTime.diff(next, NaiveDateTime.utc_now()) do
        x when x <= 60 -> "In less than a minute"
        x when x <= 60 * 10 -> "In less than 10 minutes"
        x when x <= 60 * 60 -> "In less than an hour"
        x when x <= 60 * 60 * 4 -> "In a few hours"
        x when x <= 60 * 60 * 24 -> "In less than 24 hours"
        x when x <= 60 * 60 * 24 * 4 -> "In a few days"
        _ -> "Not due for a while"
      end
    end
  end

  defp calculate_mastery(ratio, seen) when seen <= 10 and seen >= 5 do
    case ratio >= 0.9 do
      true -> :beginner
      false -> :rookie
    end
  end

  defp calculate_mastery(ratio, seen) when seen <= 15 do
    case ratio do
      r when r >= 0.9 -> :amateur
      r when r >= 0.8 -> :beginner
      _ -> :rookie
    end
  end

  defp calculate_mastery(ratio, seen) when seen <= 20 do
    case ratio do
      r when r >= 0.95 -> :pro
      r when r >= 0.9 -> :amateur
      r when r >= 0.8 -> :beginner
      _ -> :rookie
    end
  end

  defp calculate_mastery(ratio, _) do
    case ratio do
      r when r >= 0.95 -> :master
      r when r >= 0.9 -> :pro
      r when r >= 0.85 -> :amateur
      r when r >= 0.8 -> :beginner
      _ -> :rookie
    end
  end
end
