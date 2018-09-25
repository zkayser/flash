defmodule Flash.Deck do
  alias __MODULE__
  use Ecto.Schema

  @moduledoc """
  This module exposes a database-backed struct that represents
  a deck of related flashcards, and contains functions for
  manipulating and transforming `Deck`s.
  """

  @type t :: %Deck{
          title: String.t(),
          topic: Flash.Topic.t(),
          cards: list(Flash.Card.t())
        }

  schema "decks" do
    field(:title, :string)

    belongs_to(:topic, Flash.Topic)
    has_many(:cards, Flash.Card)
  end
end
