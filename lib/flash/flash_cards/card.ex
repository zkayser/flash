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
    |> validate_required([:front, :back, :deck_id])
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
