defmodule FlashWeb.DeckController do
  use FlashWeb, :controller

  def index(conn, %{"topic_id" => topic_id}) do
    case Flash.Repo.get(Flash.Topic, topic_id) do
      nil -> render_error(conn, :no_topic)
      _ -> render(conn, "index.json", decks: Flash.list_decks(topic_id))
    end
  end

  def show(conn, %{"id" => deck_id}) do
    case Flash.get_deck(deck_id) do
      nil -> render_error(conn, :no_deck)
      deck -> render(conn, "deck.json", deck: deck)
    end
  end

  def create(conn, %{"topic_id" => _, "title" => _} = params) do
    case Flash.create_deck(params) do
      {:ok, %Flash.Deck{} = deck} -> render(conn, "deck.json", deck: deck)
      {:error, errors} -> render_errors(conn, errors)
    end
  end

  def update(conn, %{"id" => id, "title" => _} = params) do
    case Flash.update_deck(Flash.get_deck(id), params) do
      {:ok, %Flash.Deck{} = deck} -> render(conn, "deck.json", deck: deck)
      {:error, errors} -> render_errors(conn, errors)
    end
  end

  def delete(conn, %{"id" => id}) do
    case Flash.delete_deck(id) do
      :ok -> json(conn, %{})
      nil -> render_error(conn, :no_deck)
      {:error, errors} -> render_errors(conn, errors)
    end
  end

  defp render_error(conn, :no_topic) do
    conn
    |> put_status(:not_found)
    |> render("error.json", %{message: "Topic not found"})
  end

  defp render_error(conn, :no_deck) do
    conn
    |> put_status(:not_found)
    |> render("error.json", %{message: "Deck not found"})
  end

  defp render_errors(conn, errors) do
    conn
    |> status_for(errors)
    |> render("error.json", %{message: errors})
  end

  defp status_for(conn, errors) when is_list(errors) do
    case "Topic_id does not exist" in errors do
      true -> put_status(conn, :not_found)
      false -> put_status(conn, :bad_request)
    end
  end
end
