defmodule Flash.Topic do
  alias __MODULE__
  use Ecto.Schema

  @moduledoc """
  This module defines the schema for `Topic`s, which
  are used to categorize and arrange flashcard decks
  in a coherent manner. `Topic`s are backed by a database
  and enforce uniqueness on the `name` of a given topic.
  """

  @type t :: %Topic{
          name: String.t(),
          decks: list(Flash.Deck.t())
        }

  schema "topics" do
    field(:name, :string)

    has_many(:decks, Flash.Deck)
  end
end
