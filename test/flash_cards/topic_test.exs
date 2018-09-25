defmodule Flash.TopicTest do
  use ExUnit.Case
  alias Flash.{Topic, Deck}

  @title "Deck"

  describe "build_deck/2" do
    test "it builds a deck association" do
      deck = Topic.build_deck(%Topic{id: 1}, %{title: @title})
      assert deck = %Deck{title: @title, topic_id: 1}
    end
  end
end
