defmodule RauversionWeb.Router do
  use RauversionExtension.UI.Web, :router

  import RauversionWeb.UserAuth

  import Plug.BasicAuth

  pipeline :bauth do
    plug :basic_auth, username: "rau", password: "raurocks"
  end

  pipeline :browser do
    plug :accepts, ["html", "json"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {RauversionExtension.UI.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug RauversionWeb.Plugs.SetLocale
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :browser_api do
    plug RemoteIp
    plug :fetch_session
    plug :fetch_current_user
    plug :accepts, ["json", "html"]
  end

  # scope "/", RauversionWeb do
  #  pipe_through :browser
  #  get "/", PageController, :index
  # end

  scope "/auth", RauversionWeb do
    pipe_through :browser

    get "/:provider", OAuthController, :request
    get "/:provider/callback", OAuthController, :callback
  end

  # import routes from extension
  use RauversionExtension.UI.Routes

  # Other scopes may use custom stacks.
  scope "/api", RauversionExtension.UI do
    pipe_through :browser_api
    post "/tracks/:track_id/events", TrackingEventsController, :show
    get "/tracks/:track_id/events", TrackingEventsController, :show
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test, :prod] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      pipe_through :bauth
      live_dashboard "/dashboard", metrics: RauversionWeb.Telemetry, ecto_repos: [Rauversion.Repo]
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

  ## Authentication routes

  scope "/", RauversionWeb do
    pipe_through [
      :browser,
      :redirect_if_user_is_authenticated,
      :redirect_if_disabled_registrations
    ]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
  end

  scope "/", RauversionWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update

    get "/users/invite/:token", UserInvitationController, :accept
    put "/users/invite/:token/:id/invite_update", UserInvitationController, :update_user
  end

  scope "/", RauversionWeb do
    pipe_through [:browser, :require_authenticated_user]

    live "/users/settings", UserSettingsLive.Index, :profile
    live "/users/settings/email", UserSettingsLive.Index, :email
    live "/users/settings/security", UserSettingsLive.Index, :security
    live "/users/settings/notifications", UserSettingsLive.Index, :notifications
    live "/users/settings/integrations", UserSettingsLive.Index, :integrations

    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email

    live "/articles/mine", ArticlesLive.Index, :mine
    live "/articles/new", ArticlesLive.New, :new
    live "/articles/edit/:id", ArticlesLive.New, :edit
    live "/articles/:slug/edit", ArticlesLive.New, :edit

    live "/reposts/new", RepostLive.Index, :new
    live "/reposts/:id/edit", RepostLive.Index, :edit

    live "/reposts/:id/show/edit", RepostLive.Show, :edit


  end


  scope "/", RauversionWeb do
    pipe_through [:browser]

    live "/", HomeLive.Index, :index

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    post "/users/confirm/:token", UserConfirmationController, :update

    live "/articles", ArticlesLive.Index, :index
    live "/articles/category/:id", ArticlesLive.Index, :category

    live "/articles/:id", ArticlesLive.Show, :show

    live "/reposts", RepostLive.Index, :index
    live "/reposts/:id", RepostLive.Show, :show


    # post "/direct_uploads" => "active_storage/direct_uploads#create", as: :rails_direct_uploads

    # get "/:username", ProfileController, :show
    live "/:username", ProfileLive.Index, :index
    live "/:username/followers", FollowsLive.Index, :followers
    live "/:username/following", FollowsLive.Index, :followings
    live "/:username/comments", FollowsLive.Index, :comments
    live "/:username/likes", FollowsLive.Index, :likes
    live "/:username/tracks/all", ProfileLive.Index, :tracks_all
    live "/:username/tracks/reposts", ProfileLive.Index, :reposts
    live "/:username/tracks/albums", ProfileLive.Index, :albums
    live "/:username/tracks/playlists", ProfileLive.Index, :playlists
    live "/:username/tracks/popular", ProfileLive.Index, :popular
    live "/:username/insights", ProfileLive.Index, :insights
  end

end
