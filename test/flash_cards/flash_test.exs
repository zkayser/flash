defmodule FlashTest do
  use ExUnit.Case, async: true
  import Flash.Factory

  setup do
    Ecto.Adapters.SQL.Sandbox.mode(Flash.Repo, :manual)
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Flash.Repo)
    topic = insert(:topic)
    deck = insert(:deck, topic_id: topic.id)

    {:ok, %{topic: topic, deck: deck}}
  end

  describe "create_topic/1" do
    test "with valid params", _ do
      assert {:ok, topic} =
               string_params_for(:topic)
               |> Flash.create_topic()
    end

    test "with empty name param", _ do
      assert {:error, errors} = Flash.create_topic(%{"name" => ""})
      assert "Name can't be blank" in errors
    end

    test "with no name param", _ do
      assert {:error, errors} = Flash.create_topic(%{})
      assert "Name can't be blank" in errors
    end
  end

  describe "create_deck/1" do
    test "with valid deck params", data do
      assert {:ok, topic} =
               string_params_for(:deck, %{topic_id: data.topic.id})
               |> Flash.create_deck()
    end

    test "with no title given", data do
      assert {:error, errors} =
               %{"topic_id" => "#{data.topic.id}"}
               |> Flash.create_deck()

      assert "Title can't be blank" in errors
    end

    test "with an empty title", data do
      assert {:error, errors} =
               %{"title" => "", "topic_id" => "#{data.topic.id}"}
               |> Flash.create_deck()

      assert "Title can't be blank" in errors
    end
  end

  describe "create_card/1" do
    test "with valid params for a single card", data do
      assert {:ok, card} =
               string_params_for(:card, %{deck_id: data.deck.id})
               |> Flash.create_card()
    end

    test "with empty front params", data do
      assert {:error, errors} =
               Flash.create_card(%{
                 "front" => "",
                 "back" => "some answer",
                 "deck_id" => data.deck.id
               })

      assert "Front can't be blank" in errors
    end

    test "with empty back params", data do
      assert {:error, errors} =
               Flash.create_card(%{
                 "front" => "some question",
                 "back" => "",
                 "deck_id" => data.deck.id
               })

      assert "Back can't be blank" in errors
    end
  end

  describe "list_topics/0" do
    test "it retrieves all topics from the database", _ do
      assert length(Flash.list_topics()) == 1
      insert_list(2, :topic)
      assert length(Flash.list_topics()) == 3
    end
  end

  describe "list_decks/1" do
    test "it retrieves all decks for the given topic", data do
      assert length(Flash.list_decks(data.topic.id)) == 1
      insert_list(2, :deck, topic_id: data.topic.id)
      assert length(Flash.list_decks(data.topic.id)) == 3
    end
  end

  describe "list_cards/1" do
    test "it retrieves all the cards for a given deck", data do
      insert_list(3, :card, deck_id: data.deck.id)
      assert length(Flash.list_cards(data.deck.id)) == 3
      insert_list(3, :card, deck_id: data.deck.id)
      assert length(Flash.list_cards(data.deck.id)) == 6
    end
  end

  describe "get_deck/1" do
    test "it retrieves the given deck when it exists", data do
      assert Flash.get_deck(data.deck.id) == data.deck
    end

    test "returns nil when deck does not exist", _ do
      assert Flash.get_deck(123) == nil
    end
  end

  describe "get_card/1" do
    test "it retrieves the given card when it exists", data do
      card = insert(:card, deck_id: data.deck.id)
      assert Flash.get_card(card.id) == card
    end

    test "it returns nil when card does not exist", _ do
      assert Flash.get_card(123) == {:error, :not_found, :card}
    end
  end

  describe "update_deck/2" do
    test "with valid params", data do
      assert {:ok, %Flash.Deck{} = deck} = Flash.update_deck(data.deck, %{"title" => "new title"})
      assert deck.title == "new title"
    end

    test "with invalid params", data do
      assert {:error, errors} = Flash.update_deck(data.deck, %{"title" => ""})
      assert "Title can't be blank" in errors
    end
  end

  describe "update_card/2" do
    test "with valid params", data do
      card = insert(:card, deck_id: data.deck.id)
      assert {:ok, %Flash.Card{} = card} = Flash.update_card(card, %{"front" => "new question"})
      assert card.front == "new question"
    end

    test "with invalid params", data do
      card = insert(:card, deck_id: data.deck.id)
      assert {:error, errors} = Flash.update_card(card, %{"front" => ""})
      assert "Front can't be blank" in errors
    end
  end

  describe "delete_deck/1" do
    test "given an existing deck", data do
      assert :ok = Flash.delete_deck(data.deck.id)
    end

    test "when the deck does not exist", _ do
      assert nil == Flash.delete_deck(123)
    end
  end

  describe "delete_card/1" do
    test "given an existing card", data do
      card = insert(:card, deck_id: data.deck.id)

      assert :ok = Flash.delete_card(card.id)
    end

    test "when the card does not exist", _ do
      assert nil == Flash.delete_card(123)
    end
  end
end
