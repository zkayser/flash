defmodule Flash.DeckControllerTest do
  use ExUnit.Case
  use FlashWeb.ConnCase
  import Flash.Factory
  alias Flash.Repo

  describe "index/2" do
    test "returns all decks", %{conn: conn, topic: topic} do
      decks = insert_list(2, :deck, topic_id: topic.id)
      [deck1, deck2] = Enum.map(decks, &(Repo.preload(&1, [:cards])))

      response =
        conn
        |> get(deck_path(conn, :index, %{"topic_id" => topic.id}))
        |> json_response(200)

      expected = %{
        "data" => [
          %{"title" => deck1.title, "cards" => length(deck1.cards)},
          %{"title" => deck2.title, "cards" => length(deck2.cards)}
        ]
      }

      assert response == expected
    end

    test "when the topic does not exist", %{conn: conn} do
      response =
        conn
        |> get(deck_path(conn, :index, %{"topic_id" => 123}))
        |> json_response(404)

      assert response == %{"error" => "Topic not found"}
    end
  end
end