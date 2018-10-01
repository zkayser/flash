defmodule FlashWeb.DeckView do
  use FlashWeb, :view

  def render("index.json", %{decks: decks}) do
    %{data: render_many(decks, __MODULE__, "deck.json")}
  end

  def render("deck.json", %{deck: deck}) do
    deck = Flash.Repo.preload(deck, [:cards])
    %{title: deck.title, cards: length(deck.cards)}
  end

  def render("error.json", %{message: message}) do
    %{error: message}
  end
end