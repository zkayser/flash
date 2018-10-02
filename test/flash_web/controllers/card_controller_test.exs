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
            "next_review" => format_test_data_time(card.next_review),
            "success_rate" => 0,
            "is_due" => true,
            "next_review_string" => "Now"
          }
        end)

      assert response == %{"data" => expected_data}
    end
  end

  describe "show/2" do
    test "with a valid card", %{conn: conn} = data do
      response =
        conn
        |> get(deck_card_path(conn, :show, data.deck, hd(data.cards)))
        |> json_response(200)

      [card|_] = data.cards
      expected_response = %{
        "front" => card.front,
        "back" => card.back,
        "times_seen" => card.times_seen,
        "next_review" => format_test_data_time(card.next_review),
        "success_rate" => 0,
        "is_due" => true,
        "next_review_string" => "Now"
      }

      assert response == expected_response
    end

    test "with a card that does not exist", %{conn: conn} = data do
      response =
        conn
        |> get(deck_card_path(conn, :show, data.deck, 123))
        |> json_response(404)

      assert response == %{"errors" => ["Card not found"]}
    end
  end

  # Creates the equivalent datetime string from
  # a NaiveDateTime used for test data.
  defp format_test_data_time(naive_datetime) do
    naive_datetime
    |> to_string()
    |> String.replace(" ", "T")
  end
end
