defmodule Flash.DeckTest do
  use ExUnit.Case
  alias Flash.{Deck, Card}

  @question "Question"
  @answer "Answer"

  describe "build_card/2" do
    test "it takes a question and answer and returns a Card" do
      card = Deck.build_card(%Deck{id: 1}, %{front: @question, back: @answer})
      assert %Card{front: @question, back: @answer} = card
    end
  end

  describe "changeset/2" do
    test "requires title to be present" do
      changeset = Deck.changeset(%Deck{}, %{title: ""})
      refute changeset.valid?
    end

    test "requires title to be non-nil" do
      changeset = Deck.changeset(%Deck{}, %{title: nil})
      refute changeset.valid?
    end

    test "valid changeset" do
      assert Deck.changeset(%Deck{}, %{title: "Hello"}).valid?
    end
  end
end
