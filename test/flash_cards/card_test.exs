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

  describe "update/2" do
    test "when review is successful" do
      card = %Card{id: 1}

      expected_query =
        from(c in Card, where: c.id == ^1, update: [inc: [successes: 1, times_seen: 1]])

      Helpers.assert_query_equal(Card.update(card, true), expected_query)
    end

    test "when review is unsuccessful" do
      card = %Card{id: 1}

      expected_query =
        from(c in Card, where: c.id == ^1, update: [inc: [failures: 1, times_seen: 1]])

      Helpers.assert_query_equal(Card.update(card, false), expected_query)
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

    test "when the card is valid" do
      changeset = Card.changeset(%Card{}, %{front: @question, back: @answer})
      assert changeset.valid?
    end
  end
end
