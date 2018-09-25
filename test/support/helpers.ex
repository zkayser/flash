defmodule Flash.Helpers do
  import ExUnit.Assertions

  @moduledoc """
  This module exposes helper functions for testing purposes
  """

  @doc """
  Takes two Ecto queries and compares them for equality
  by stripping out code-related metadata.
  """
  @spec assert_query_equal(Ecto.Query.t(), Ecto.Query.t()) :: ExUnit.state()
  def assert_query_equal(actual_query, expected_query) do
    remove_code_info = fn query ->
      query = Map.from_struct(query)
      wheres = query[:wheres]
      updates = query[:updates]
      cleansed_wheres = Enum.map(wheres, fn clause -> Map.drop(clause, [:file, :line]) end)
      cleansed_updates = Enum.map(updates, fn clause -> Map.drop(clause, [:file, :line]) end)

      query
      |> Map.put(:wheres, cleansed_wheres)
      |> Map.put(:updates, cleansed_updates)
    end

    assert remove_code_info.(actual_query) == remove_code_info.(expected_query)
  end
end
