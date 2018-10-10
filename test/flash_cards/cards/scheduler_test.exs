defmodule Flash.SchedulerTest do
  use ExUnit.Case
  alias Flash.Card
  alias Flash.Card.Scheduler

  describe "schedule_next_review/1" do
    test "zero consecutive successful reviews" do
      card = %Card{}
      assert Scheduler.schedule_next_review(card) == card.next_review
    end

    test "one consecutive successful review" do
      card = %Card{streak: 1}
      eight_hours_from_now = NaiveDateTime.add(NaiveDateTime.utc_now(), 60 * 60 * 8, :seconds)
      scheduled_review = Scheduler.schedule_next_review(card)
      assert_in_delta(
        NaiveDateTime.diff(scheduled_review, eight_hours_from_now, :second),
        1,
        1)
    end

    test "two consecutive successful reviews" do
      card = %Card{streak: 2}
      one_day_from_now = NaiveDateTime.add(NaiveDateTime.utc_now(), 60 * 60 * 24, :second)
      scheduled_review = Scheduler.schedule_next_review(card)
      assert_in_delta(
        NaiveDateTime.diff(scheduled_review, one_day_from_now, :second),
        -1,
        1
      )
    end

    test "three consecutive successful reviews" do
      card = %Card{streak: 3}
      two_days_from_now = NaiveDateTime.add(NaiveDateTime.utc_now(), 60 * 60 * 24 * 2, :second)
      scheduled_review = Scheduler.schedule_next_review(card)
      assert_in_delta(
        NaiveDateTime.diff(scheduled_review, two_days_from_now, :second),
        -1,
        1
      )
    end

    test "four consecutive successful reviews" do
      card = %Card{streak: 4}
      four_days_from_now = NaiveDateTime.add(NaiveDateTime.utc_now(), 60 * 60 * 24 * 4, :second)
      scheduled_review = Scheduler.schedule_next_review(card)
      assert_in_delta(
        NaiveDateTime.diff(scheduled_review, four_days_from_now, :second),
        -1,
        1
      )
    end

    test "five consecutive successful reviews" do
      card = %Card{streak: 5}
      eight_days_from_now = NaiveDateTime.add(NaiveDateTime.utc_now(), 60 * 60 * 24 * 8, :second)
      scheduled_review = Scheduler.schedule_next_review(card)
      assert_in_delta(
        NaiveDateTime.diff(scheduled_review, eight_days_from_now, :second),
        -1,
        1
      )
    end

    test "six consecutive successful reviews" do
      card = %Card{streak: 6}
      sixteen_days_from_now = NaiveDateTime.add(NaiveDateTime.utc_now(), 60 * 60 * 24 * 16, :second)
      scheduled_review = Scheduler.schedule_next_review(card)
      assert_in_delta(
        NaiveDateTime.diff(scheduled_review, sixteen_days_from_now, :second),
        -1,
        1
      )
    end

    test "seven plus consecutive successful reviews" do
      card = %Card{streak: 7}
      thirty_two_days_from_now = NaiveDateTime.add(NaiveDateTime.utc_now(), 60 * 60 * 24 * 32, :second)
      scheduled_review = Scheduler.schedule_next_review(card)
      assert_in_delta(
        NaiveDateTime.diff(scheduled_review, thirty_two_days_from_now, :second),
        -1,
        1
      )
    end
  end
end
