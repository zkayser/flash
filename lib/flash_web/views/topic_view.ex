defmodule FlashWeb.TopicView do
  alias FlashWeb.DeckView
  use FlashWeb, :view

  def render("topics.json", %{topics: topics}) do
    %{data: Enum.map(topics, &render("topic.json", %{topic: &1}))}
  end

  def render("topic.json", %{topic: topic}) do
    %{title: topic.name,
      id: topic.id,
      sub_topics: render_many(topic.sub_topics, __MODULE__, "topic.json"),
      decks: render_many(topic.decks, DeckView, "deck.json")
      }
  end
end
