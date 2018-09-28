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
end
