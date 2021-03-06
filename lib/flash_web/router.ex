defmodule FlashWeb.Router do
  use FlashWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(CORSPlug, origin: ["http://localhost:8080", "http://0.0.0.0:8080"])
    plug(:accepts, ["json"])
  end

  scope "/", FlashWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  scope "/api", FlashWeb do
    pipe_through(:api)

    resources("/topics", TopicController, except: [:new, :edit])
    options("/topics", TopicController, :create)

    resources "/decks", DeckController, except: [:new, :edit] do
      resources("/cards", CardController, except: [:new, :edit])
    end
  end
end
