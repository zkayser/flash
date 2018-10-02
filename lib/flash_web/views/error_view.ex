defmodule FlashWeb.ErrorView do
  use FlashWeb, :view

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
end
