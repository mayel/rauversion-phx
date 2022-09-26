defmodule RauversionExtension.UI.Routes do
  defmacro __using__(_) do
    quote do

  scope "/", RauversionExtension.UI do
    pipe_through :browser_embed
    get "/embed/:track_id", EmbedController, :show
    get "/embed/:track_id/private", EmbedController, :private

    get "/embed/sets/:playlist_id", EmbedController, :show_playlist
    get "/embed/sets/:playlist_id/private", EmbedController, :private_playlist

    post "/webhooks/stripe", WebhooksController, :create
  end

  # Other scopes may use custom stacks.
  scope "/api", RauversionExtension.UI do
    pipe_through :browser_api

  end


  scope "/", RauversionExtension.UI do
    pipe_through [:browser, :require_authenticated_user]

    live "/tickets/qr/:signed_id", QrLive.Index, :index

    get "/oembed", OEmbedController, :create

    live "/articles/mine", ArticlesLive.Index, :mine
    live "/articles/new", ArticlesLive.New, :new
    live "/articles/edit/:id", ArticlesLive.New, :edit
    live "/articles/:slug/edit", ArticlesLive.New, :edit

    live "/events/mine", EventsLive.Index, :mine
    live "/events/new", EventsLive.New, :new
    live "/events/edit/:id", EventsLive.New, :edit
    live "/events/:slug/edit", EventsLive.New, :edit

    live "/events/:slug/payment_success", EventsLive.Show, :payment_success
    live "/events/:slug/payment_failure", EventsLive.Show, :payment_fail
    live "/events/:slug/payment_cancel", EventsLive.Show, :payment_cancel

    live "/events/:slug/edit/schedule", EventsLive.New, :schedule
    live "/events/:slug/edit/tickets", EventsLive.New, :tickets
    live "/events/:slug/edit/order_form", EventsLive.New, :order_form
    live "/events/:slug/edit/widgets", EventsLive.New, :widgets
    live "/events/:slug/edit/tax", EventsLive.New, :tax
    live "/events/:slug/edit/attendees", EventsLive.New, :attendees
    live "/events/:slug/edit/sponsors", EventsLive.New, :sponsors

    live "/tracks/new", TrackLive.New, :new
    live "/tracks/:id/edit", TrackLive.Index, :edit

    live "/tracks/:id/show/edit", TrackLive.Show, :edit

    live "/reposts/new", RepostLive.Index, :new
    live "/reposts/:id/edit", RepostLive.Index, :edit

    live "/reposts/:id/show/edit", RepostLive.Show, :edit

    live "/playlists/new", PlaylistLive.Index, :new
    live "/playlists/:id/edit", PlaylistLive.Index, :edit
    live "/playlists/:id/show/edit", PlaylistLive.Show, :edit
  end

  scope "/active_storage", RauversionExtension.UI do
    pipe_through [:active_storage]

    # get "/blobs/proxy/:signed_id/*filename" => "active_storage/blobs/proxy#show", as: :rails_service_blob_proxy
    get(
      "/blobs/proxy/:signed_id/*filename",
      ActiveStorage.Blobs.ProxyController,
      :show
    )

    # get "/blobs/redirect/:signed_id/*filename" => "active_storage/blobs/redirect#show", as: :rails_service_blob
    get(
      "/blobs/redirect/:signed_id/*filename",
      ActiveStorage.Blobs.RedirectController,
      :show
    )

    # get("/blobs/:signed_id/*filename", ActiveStorage.Blob.ProxyController, :show)
    # get "/blobs/:signed_id/*filename" => "active_storage/blobs/redirect#show"

    get(
      "/representations/redirect/:signed_blob_id/:variation_key/*filename",
      ActiveStorage.Representations.RedirectController,
      :show
    )

    get(
      "/representations/proxy/:signed_blob_id/:variation_key/*filename",
      ActiveStorage.Representations.ProxyController,
      :show
    )

    # get "/representations/redirect/:signed_blob_id/:variation_key/*filename" => "active_storage/representations/redirect#show", as: :rails_blob_representation
    # get "/representations/proxy/:signed_blob_id/:variation_key/*filename" => "active_storage/representations/proxy#show", as: :rails_blob_representation_proxy
    # get "/representations/:signed_blob_id/:variation_key/*filename" => "active_storage/representations/redirect#show"

    # get  "/disk/:encoded_key/*filename" => "active_storage/disk#show", as: :rails_disk_service
    # put  "/disk/:encoded_token" => "active_storage/disk#update", as: :update_rails_disk_service
    get(
      "/disk/:encoded_key/*filename",
      ActiveStorage.DiskController,
      :show
    )

    put(
      "/disk/:encoded_token",
      ActiveStorage.DiskController,
      :update
    )

    post(
      "/direct_uploads",
      ActiveStorage.DirectUploadsController,
      :create
    )
  end

  scope "/", RauversionExtension.UI do
    pipe_through [:browser]

    live "/rauversion", HomeLive.Index, :index

    live "/events", EventsLive.Index, :index
    live "/events/:id", EventsLive.Show, :show
    live "/events/:id/tickets", TicketsLive.Index, :index

    live "/tracks", TrackLive.Index, :index

    live "/tracks/:id", TrackLive.Show, :show
    live "/tracks/:id/private", TrackLive.Show, :private

    live "/playlists", PlaylistLive.Index, :index
    live "/playlists/:id", PlaylistLive.Show, :show
    live "/playlists/:id/private", PlaylistLive.Show, :private

    # post "/direct_uploads" => "active_storage/direct_uploads#create", as: :rails_direct_uploads

    live "/profile/:username", ProfileLive.Index, :index
    live "/profile/:username/followers", FollowsLive.Index, :followers
    live "/profile/:username/following", FollowsLive.Index, :followings
    live "/profile/:username/comments", FollowsLive.Index, :comments
    live "/profile/:username/likes", FollowsLive.Index, :likes
    live "/profile/:username/tracks/all", ProfileLive.Index, :tracks_all
    live "/profile/:username/tracks/reposts", ProfileLive.Index, :reposts
    live "/profile/:username/tracks/albums", ProfileLive.Index, :albums
    live "/profile/:username/tracks/playlists", ProfileLive.Index, :playlists
    live "/profile/:username/tracks/popular", ProfileLive.Index, :popular
    live "/profile/:username/insights", ProfileLive.Index, :insights
  end

    end
  end
end
