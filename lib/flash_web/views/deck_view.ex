defmodule FlashWeb.DeckView do
  use FlashWeb, :view

  def render("index.json", %{decks: decks}) do
    %{data: render_many(decks, __MODULE__, "deck.json")}
  end

  def render("deck.json", %{deck: deck}) do
    %{title: deck.title, id: deck.id}
  end

  def render("error.json", %{message: messages}) when is_list(messages) do
    %{error: format_messages(messages)}
  end

  def render("error.json", %{message: message}) do
    %{error: format_message(message)}
  end

  defp format_messages(messages) when is_list(messages) do
    messages
    |> Enum.map(&format_message/1)
  end

  defp format_message(message) do
    String.replace(message, "Topic_id does not exist", "Topic not found")
  end
end