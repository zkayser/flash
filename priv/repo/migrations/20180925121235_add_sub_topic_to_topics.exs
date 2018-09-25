defmodule Flash.Repo.Migrations.AddSubTopicToTopics do
  use Ecto.Migration

  def change do
    alter table("topics") do
      add(:topic_id, references("topics"))
    end
  end
end
