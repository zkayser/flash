defmodule Flash.CardTest do
  use ExUnit.Case
  alias Flash.{Card, Helpers}
  import Ecto.Query

  describe "mastery/2" do
    test "returns rookie when a card has 0 successes" do
      assert Card.mastery(%Card{times_seen: 1}) == :rookie
    end

    test "returns rookie when card has not yet been seen" do
      assert Card.mastery(%Card{}) == :rookie
    end

    test "returns beginner when seen >= 5 times and success rate > 90%" do
      assert Card.mastery(%Card{times_seen: 10, successes: 9}) == :beginner
    end

    test "returns rookie when seen < 5 times" do
      assert Card.mastery(%Card{times_seen: 4, successes: 4}) == :rookie
    end

    test "returns amateur when seen < 15 times and success rate > 90%" do
      assert Card.mastery(%Card{times_seen: 15, successes: 14}) == :amateur
    end

    test "returns beginner when seen < 15 times and success rate >= 80%" do
      assert Card.mastery(%Card{times_seen: 15, successes: 13}) == :beginner
    end

    test "returns rookie when seen < 10 times and success rate < 80%" do
      assert Card.mastery(%Card{times_seen: 15, successes: 11}) == :rookie
    end

    test "returns pro when seen < 20 times and success rate >= 95%" do
      assert Card.mastery(%Card{times_seen: 20, successes: 19}) == :pro
    end

    test "returns amateur when seen < 20 times and success rate > 90%" do
      assert Card.mastery(%Card{times_seen: 20, successes: 18}) == :amateur
    end

    test "returns beginner when seen < 20 and success rate >= 80%" do
      assert Card.mastery(%Card{times_seen: 20, successes: 16}) == :beginner
    end

    test "returns rookie when seen < 20 and success rate < 80%" do
      assert Card.mastery(%Card{times_seen: 20, successes: 15}) == :rookie
    end

    test "returns master when seen > 20 times and success rate >= 95%" do
      assert Card.mastery(%Card{times_seen: 21, successes: 20}) == :master
    end

    test "returns pro when seen > 20 times and success rate >= 90%" do
      assert Card.mastery(%Card{times_seen: 100, successes: 90}) == :pro
    end

    test "returns amateur when seen > 20 and success rate >= 85%" do
      assert Card.mastery(%Card{times_seen: 100, successes: 85}) == :amateur
    end

    test "returns beginner when seen > 20 and success rate >= 80%" do
      assert Card.mastery(%Card{times_seen: 100, successes: 80}) == :beginner
    end

    test "returns rookie when seen > 20 and success rate < 80%" do
      assert Card.mastery(%Card{times_seen: 100, successes: 79}) == :rookie
    end
  end

  describe "review_passed/2" do
    test "when review is successful" do
      changeset =
        %Card{id: 1}
        |> Card.review_passed?("true")

      assert changeset.valid?
      assert changeset.changes[:times_seen] == 1
      assert changeset.changes[:successes] == 1
    end

    test "when review is unsuccessful" do
      changeset =
        %Card{id: 1}
        |> Card.review_passed?("false")

      assert changeset.valid?
      assert %{times_seen: 1} == changeset.changes
    end
  end

  @question "Question"
  @answer "Answer"
  @error_msg "can't be blank"
  @error {@error_msg, [validation: :required]}

  describe "changeset/2" do
    test "when front is empty" do
      changeset = Card.changeset(%Card{}, %{front: ""})
      refute changeset.valid?
      assert {:front, @error} in changeset.errors
    end

    test "when front is nil" do
      changeset = Card.changeset(%Card{}, %{front: nil})
      refute changeset.valid?
      assert {:front, @error} in changeset.errors
    end

    test "when back is empty" do
      changeset = Card.changeset(%Card{}, %{back: ""})
      refute changeset.valid?
      assert {:back, @error} in changeset.errors
    end

    test "when back is nil" do
      changeset = Card.changeset(%Card{}, %{back: nil})
      refute changeset.valid?
      assert {:back, @error} in changeset.errors
    end

    test "when deck_id is missing" do
      refute Card.changeset(%Card{}, %{front: @question, back: @answer}).valid?
    end

    test "when the card is valid" do
      assert Card.changeset(%Card{}, %{front: @question, back: @answer, deck_id: 1}).valid?
    end
  end

  describe "cards_for_deck/1" do
    test "it creates a query to retrieve all cards for a given deck" do
      expected_query = from c in Card, where: c.deck_id == ^1
      Helpers.assert_query_equal(Card.cards_for_deck(1), expected_query)
    end
  end

  describe "success_rate/1" do
    test "when card is brand new/never seen" do
      assert Card.success_rate(%Card{}) == 0
    end

    test "when card has a 50% success rate" do
      card = %Card{successes: 2, times_seen: 4}
      assert Card.success_rate(card) == 50
    end

    test "when card has a 100% success rate" do
      card = %Card{successes: 4, times_seen: 4}
      assert Card.success_rate(card) == 100
    end

    test "when card has a success rate not cleanly divisble by 100" do
      card = %Card{successes: 2, times_seen: 3}
      assert Card.success_rate(card) == 67
    end
  end

  describe "is_due?/1" do
    test "when is past due" do
      now = NaiveDateTime.utc_now()
      card = %Card{next_review: NaiveDateTime.add(now, -60, :seconds)}

      assert Card.is_due?(card)
    end

    test "when not past due" do
      now = NaiveDateTime.utc_now()
      card = %Card{next_review: NaiveDateTime.add(now, 60, :seconds)}

      refute Card.is_due?(card)
    end
  end

  describe "next_review/1" do
    test "when due within 10 minutes" do
      now = NaiveDateTime.utc_now()
      card = %Card{next_review: NaiveDateTime.add(now, 60 * 10, :seconds)}

      assert Card.next_review(card) == "In less than 10 minutes"
    end

    test "when due now" do
      card = %Card{next_review: NaiveDateTime.utc_now()}

      assert Card.next_review(card) == "Now"
    end

    test "when do within a minute" do
      now = NaiveDateTime.utc_now()
      card = %Card{next_review: NaiveDateTime.add(now, 60, :seconds)}

      assert Card.next_review(card) == "In less than a minute"
    end

    test "when due within an hour" do
      now = NaiveDateTime.utc_now()
      card = %Card{next_review: NaiveDateTime.add(now, 60 * 60, :seconds)}

      assert Card.next_review(card) == "In less than an hour"
    end

    test "when due within 4 hours" do
      now = NaiveDateTime.utc_now()
      card = %Card{next_review: NaiveDateTime.add(now, 60 * 60 * 4, :seconds)}

      assert Card.next_review(card) == "In a few hours"
    end

    test "when due within 24 hours" do
      now = NaiveDateTime.utc_now()
      card = %Card{next_review: NaiveDateTime.add(now, 60 * 60 * 24, :seconds)}

      assert Card.next_review(card) == "In less than 24 hours"
    end

    test "when due within 4 days" do
      now = NaiveDateTime.utc_now()
      card = %Card{next_review: NaiveDateTime.add(now, 60 * 60 * 24 * 4, :seconds)}

      assert Card.next_review(card) == "In a few days"
    end

    test "when due in more than 4 days" do
      now = NaiveDateTime.utc_now()
      card = %Card{next_review: NaiveDateTime.add(now, 60 * 60 * 24 * 5, :seconds)}

      assert Card.next_review(card) == "Not due for a while"
    end
  end
end
