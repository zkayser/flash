defmodule FlashWeb.ErrorView do
  use FlashWeb, :view

  def render("500.json", data) do
    %{errors: data}
  end
end