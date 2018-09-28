defmodule Flash.Topic do
  alias __MODULE__
  alias Flash.Deck
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  This module defines the schema for `Topic`s, which
  are used to categorize and arrange flashcard decks
  in a coherent manner. `Topic`s are backed by a database
  and enforce uniqueness on the `name` of a given topic.
  """

  @type t :: %Topic{}

  schema "topics" do
    field(:name, :string)

    has_many(:decks, Deck)
    has_many(:sub_topics, Topic)
    belongs_to(:topic, Topic)

    timestamps()
  end

  @spec build_deck(t(), map()) :: Deck.t()
  def build_deck(%Topic{} = topic, %{title: _} = attrs) do
    Ecto.build_assoc(topic, :decks, attrs)
  end

  @spec build_sub_topic(t(), map()) :: t()
  def build_sub_topic(%Topic{} = parent, %{name: _} = attrs) do
    Ecto.build_assoc(parent, :sub_topics, attrs)
  end

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(%Topic{} = topic, attrs \\ %{}) do
    topic
    |> cast(attrs, [:name])
    |> validate_required(:name)
  end
end
