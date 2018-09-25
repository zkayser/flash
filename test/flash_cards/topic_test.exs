defmodule Flash.TopicTest do
  use ExUnit.Case
  alias Flash.{Topic, Deck}

  @title "Deck"
  @sub_topic "Sub Topic"

  describe "build_deck/2" do
    test "it builds a deck association" do
      deck = Topic.build_deck(%Topic{id: 1}, %{title: @title})
      assert %Deck{title: @title, topic_id: 1} = deck
    end
  end

  describe "build_sub_topic/2" do
    test "it builds sub_topic associations" do
      sub_topic = Topic.build_sub_topic(%Topic{id: 1}, %{name: @sub_topic})
      assert %Topic{name: @sub_topic, topic_id: 1} = sub_topic
    end
  end
end
