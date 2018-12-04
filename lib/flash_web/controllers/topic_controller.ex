defmodule FlashWeb.TopicController do
  use FlashWeb, :controller

  action_fallback(FlashWeb.FallbackController)

  def create(conn, %{"name" => _} = params) do
    with {:ok, topic} <- Flash.create_topic(params) do
      render(conn, "topic.json", %{topic: topic})
    end
  end

  def index(conn, _) do
    render(conn, "topics.json", %{topics: Flash.list_topics()})
  end
end
