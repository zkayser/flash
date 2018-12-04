defmodule Flash.DeckControllerTest do
  use ExUnit.Case
  use FlashWeb.ConnCase
  import Flash.Factory
  alias Flash.Repo

  @title "some title"

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
          %{"title" => deck1.title, "id" => deck1.id},
          %{"title" => deck2.title, "id" => deck2.id}
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

    test "when there are no decks for a topic", %{conn: conn} do
      topic = insert(:topic)
      response =
        conn
        |> get(deck_path(conn, :index, %{"topic_id" => topic.id}))
        |> json_response(200)

      assert response == %{"data" => []}
    end
  end

  describe "show/2" do
    test "when there is a deck to show", %{conn: conn, topic: topic} do
      deck = insert(:deck, topic_id: topic.id)

      response =
        conn
        |> get(deck_path(conn, :show, deck))
        |> json_response(200)

      expected_response = %{"title" => deck.title, "id" => deck.id}

      assert response == expected_response
    end

    test "when the deck does not exist", %{conn: conn} do
      response =
        conn
        |> get(deck_path(conn, :show, 123))
        |> json_response(404)

        assert response == %{"error" => "Deck not found"}
    end
  end

  describe "create/2" do
    test "with valid params", %{conn: conn, topic: topic} do
      response =
        conn
        |> post(deck_path(conn, :create, %{"topic_id" => topic.id, "title" => @title}))
        |> json_response(200)

      assert %{"title" => @title, "id" => _} = response
    end

    test "with invalid topic id", %{conn: conn} do
      response =
        conn
        |> post(deck_path(conn, :create, %{"topic_id" => 123, "title" => @title}))
        |> json_response(404)

      assert response == %{"error" => ["Topic not found"]}
    end

    test "with empty title", %{conn: conn, topic: topic} do
      response =
        conn
        |> post(deck_path(conn, :create, %{"topic_id" => topic.id, "title" => ""}))
        |> json_response(400)

      assert response == %{"error" => ["Title can't be blank"]}
    end
  end

  describe "update/2" do
    test "with valid params", %{conn: conn, topic: topic} do
      deck = insert(:deck, topic_id: topic.id)
      response =
        conn
        |> patch(deck_path(conn, :update, deck, %{"title" => @title}))
        |> json_response(200)

      assert response == %{"title" => @title, "id" => deck.id}
    end

    test "with invalid params", %{conn: conn, topic: topic} do
      deck = insert(:deck, topic_id: topic.id)
      response =
        conn
        |> patch(deck_path(conn, :update, deck, %{"title" => ""}))
        |> json_response(400)

      assert response == %{"error" => ["Title can't be blank"]}
    end
  end

  describe "delete/2" do
    test "with an existing deck", %{conn: conn, topic: topic} do
      deck = insert(:deck, topic_id: topic.id)
      conn
      |> delete(deck_path(conn, :delete, deck))
      |> json_response(200)
    end

    test "with a deck that does not exist", %{conn: conn} do
      response =
        conn
        |> delete(deck_path(conn, :delete, 123))
        |> json_response(404)

      assert response == %{"error" => "Deck not found"}
    end
  end
end
