defmodule Flash.SchedulerTest do
  use ExUnit.Case
  alias Flash.Card.Scheduler
  import Flash.Factory

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Flash.Repo)
    topic = insert(:topic)
    deck = insert(:deck, topic_id: topic.id)
    card = insert(:card, deck_id: deck.id)

    {:ok, %{card: card}}
  end

  describe "schedule_next_review/2" do
    test "when the user failed to recall the flash card information", %{card: card} do
      assert Scheduler.schedule_next_review(card, false) == card.next_review
    end
  end
end
