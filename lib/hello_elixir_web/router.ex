defmodule HelloElixirWeb.Router do
  use HelloElixirWeb, :router

  pipeline :browser do
    plug :accepts, ["html"] # at the end of plugs we write halt() so that it informs if the plug pipeline needs to stop
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {HelloElixirWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug HelloElixirWeb.Plugs.Locale, "en"
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  #creating a new pipeline
  pipeline :review_checker do
    plug :browser # calling it here only since a pipeline is a plug only(simpifying the pipeline call below)
    plug :ensure_authenticated_user
    plug :ensure_user_owns_review
  end


  scope "/", HelloElixirWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/hello_elixir", HelloElixirController, :index  #we are creating another router : we need to create a module
    #HelloElixirWeb.HelloElixirController with an index/2 function in hello_elixir_web/controllers/
    get "/hello_elixir/:messenger", HelloElixirController, :show

    # resources "/users", UserController
    # resources "/posts", PostController, only: [:index, :show, :edit, :update]
    #resources "/comments", CommentController, except: [:delete]

    #!!!!!!!!!!!!!!!!!!!!!nested route (posts has many-to-one ralationship with users)!!!!!!!!!!!!!!!!
    # resources "/users", UserController do
    #   resources "/posts", PostController
    # end

    # resources "/reviews", ReviewController

    # scope "/admin", HelloElixirWeb.Admin do
    #   # pipe_through :browser

    #   resources "/reviews", ReviewController
    # end

  end

    # scope "/admin", HelloElixirWeb.Admin, as: :admin do
    #   pipe_through :browser #also works if this line isn't there but i don't know the effects

    #   resources "/users", UserController
    #   resources "/images", ImageController
    #   resources "/reviews", ReviewController
    # end


    #suppose we have a versioned api

    scope "/api", HelloElixirWeb  do
      pipe_through :api

        resources "/reviews", ReviewController

      end
    end
  # Other scopes may use custom stacks.
  # scope "/api", HelloElixirWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: HelloElixirWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
