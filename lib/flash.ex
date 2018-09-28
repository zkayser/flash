defmodule Flash do
  alias Flash.{Topic, Deck, Card, Repo}
  @moduledoc """
  Flash keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @typep success :: {:ok, Topic.t() | Deck.t() | Card.t()}
  @typep error :: {:error, list(String.t())}
  @type result :: success | error

  @doc """
  Creates a new Topic struct and inserts it into
  the database. Topics must have a name to be valid.
  """
  @spec create_topic(map()) :: result()
  def create_topic(attrs) when is_map(attrs) do
    changeset = Topic.changeset(%Topic{}, attrs)
    case changeset.valid? do
      true -> insert(changeset)
      false -> handle_errors(changeset)
    end
  end

  @doc """
  Creates a new Deck struct and inserts it into the
  database. Decks must be given a title to be valid
  """
  @spec create_deck(map()) :: result()
  def create_deck(attrs) when is_map(attrs) do
    changeset = Deck.changeset(%Deck{}, attrs)
    case changeset.valid? do
      true -> insert(changeset)
      false -> handle_errors(changeset)
    end
  end

  @doc """
  Creates a new Card struct and inserts it into the
  database. Validation of the attributes are handled
  by the Card module's changeset function; however,
  the card must be given both a `front` and a `back`
  attribute to be valid. These correspond to "question"
  and "answer" pairs to be quizzed by the flashcard.
  """
  @spec create_card(map()) :: result()
  def create_card(attrs) when is_map(attrs) do
    changeset = Card.changeset(%Card{}, attrs)
    case changeset.valid? do
      true -> insert(changeset)
      false -> handle_errors(changeset)
    end
  end

  defp insert(%Ecto.Changeset{} = changeset) do
    case Repo.insert(changeset) do
      {:ok, struct} -> {:ok, struct}
      {:error, changeset} -> handle_errors(changeset)
    end
  end

  defp handle_errors(%Ecto.Changeset{} = changeset) do
    errors = Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)

    {:error, Enum.map(errors, fn {key, value} ->
      String.capitalize("#{key} #{value}")
    end)}
  end
end
