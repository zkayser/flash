defmodule Flash.Repo.Migrations.RemoveFailuresFromCard do
  use Ecto.Migration

  def change do
    alter table(:cards) do
      remove :failures
    end
  end
end
