defmodule Flash.Factory do
  @moduledoc false
  use ExMachina.Ecto, repo: Flash.Repo
  use Flash.CardFactory
  use Flash.DeckFactory
  use Flash.TopicFactory
end
