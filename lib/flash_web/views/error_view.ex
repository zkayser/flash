defmodule FlashWeb.ErrorView do
  use FlashWeb, :view
  require Logger

  def render("500.json", data) do
    %{errors: data}
  end

  def render("404.json", %{message: messages}) when is_list(messages) do
    %{errors: messages}
  end

  def render("404.json", %{message: message}) do
    %{errors: [message]}
  end

  def render("400.json", %{message: messages}) when is_list(messages) do
    %{errors: messages}
  end

  def render("400.json", %{message: message}) do
    %{errors: [message]}
  end

  def render("400.json", data) do
    Logger.warn "Received unknown 400 error: #{inspect(data, pretty: true)}"
    %{errors: ["An unknown error occurred."]}
  end
end
