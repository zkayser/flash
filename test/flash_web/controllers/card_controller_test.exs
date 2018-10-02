defmodule FlashWeb.CardControllerTest do
  use ExUnit.Case
  use FlashWeb.ConnCase
  import Flash.Factory
  alias Flash.Repo

  setup context do
    deck = insert(:deck, topic_id: context.topic.id)
    cards = insert_list(3, :card, deck_id: deck.id)

    {:ok, %{conn: context.conn, topic: context.topic, deck: Repo.preload(deck, :cards), cards: cards}}
  end

  describe "index/2" do
    test "it shows all of the cards for a deck", %{conn: conn} = data do
      response =
        conn
        |> get(deck_card_path(conn, :index, data.deck))
        |> json_response(200)

      expected_data =
        data.cards
        |> Enum.map(fn card ->
          %{"front" => card.front,
            "back" => card.back,
            "times_seen" => card.times_seen,
            "success_rate" => 0,
            "is_due" => true,
            "next_review" => "Now"
          }
        end)

      assert response == %{"data" => expected_data}
    end
  end
end
