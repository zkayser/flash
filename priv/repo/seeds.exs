# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Flash.Repo.insert!(%Flash.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

topic_attrs = [
  %{name: "Elixir"},
  %{name: "C"},
  %{name: "Swift"},
  %{name: "JavaScript"},
  %{name: "Elm"},
  %{name: "ReasonML"}
]

Enum.each(topic_attrs, fn attrs ->
  Flash.create_deck(attrs)
end)