defmodule Flash.DeckFactory do
  @moduledoc false
  defmacro __using__(_opts) do
    quote do
      def deck_factory do
        %Flash.Deck{
          title: "My deck"
        }
      end

      def with_cards(%Flash.Deck{} = deck) do
        insert_list(3, :card, deck: deck)
        deck
      end
    end
  end
end
