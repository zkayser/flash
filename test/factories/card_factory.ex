defmodule Flash.CardFactory do
  @moduledoc false
  defmacro __using__(_opts) do
    quote do
      def card_factory do
        %Flash.Card{
          front: "Some question",
          back: "Some answer"
        }
      end
    end
  end
end
