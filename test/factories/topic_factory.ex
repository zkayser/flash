defmodule Flash.TopicFactory do
  @moduledoc false
  defmacro __using__(_opts) do
    quote do
      def topic_factory do
        %Flash.Topic{
          name: sequence(:name, &"Topic-#{&1}")
        }
      end

      def with_deck(%Flash.Topic{} = topic) do
        insert(:deck, topic: topic)
        topic
      end
    end
  end
end
