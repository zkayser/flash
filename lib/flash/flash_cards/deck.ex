defmodule Flash.Deck do
  alias __MODULE__
  alias Flash.{Card, Topic}
  import Ecto.{Changeset, Query}
  use Ecto.Schema

  @moduledoc """
  This module exposes a database-backed struct that represents
  a deck of related flashcards, and contains functions for
  manipulating and transforming `Deck`s.
  """

  @type t :: %Deck{}

  schema "decks" do
    field(:title, :string)

    belongs_to(:topic, Topic)
    has_many(:cards, Card)

    timestamps()
  end

  @spec build_card(t(), map()) :: Card.t()
  def build_card(%Deck{} = deck, %{front: _, back: _} = attrs) do
    Ecto.build_assoc(deck, :cards, attrs)
  end

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(%Deck{} = struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :topic_id])
    |> foreign_key_constraint(:topic_id)
    |> validate_required([:title, :topic_id])
  end

  @spec decks_for_topic(non_neg_integer) :: Ecto.Query.t
  def decks_for_topic(topic_id) do
    from d in Deck,
    where: d.topic_id == ^topic_id
  end
end
