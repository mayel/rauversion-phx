defmodule RauversionExtension.UI.PlaylistLive.PlaylistListComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionExtension.UI.Web, :live_component
  alias Rauversion.{Playlists}

  # @impl true
  # def update(assigns, socket) do
  #   {:ok,
  #    socket
  #    |> assign(assigns)
  #    |> assign(page: 1)
  #    |> assign(playlists: list_playlists(assigns))}
  # end

  @impl true
  def preload(assigns) do
    assigns = List.first(assigns)
    page = 1
    playlists = list_playlists(page, assigns)
    tracks_meta = track_meta(playlists)

    [
      Map.merge(assigns, %{
        page: 1,
        playlists: playlists,
        track_meta: tracks_meta
      })
    ]
  end

  @impl true
  def mount(socket) do
    # socket = assign(socket, :tracks, Tracks.list_tracks())
    {:ok, socket, temporary_assigns: [tracks: []]}
  end

  defp list_playlists(page, assigns) do
    Rauversion.Playlists.list_playlists_by_user(
      assigns.profile,
      assigns[:current_user]
    )
    |> Rauversion.Repo.paginate(page: page, page_size: 5)
  end

  defp track_meta(tracks) do
    %{
      page_number: tracks.page_number,
      page_size: tracks.page_size,
      total_entries: tracks.total_entries,
      total_pages: tracks.total_pages
    }
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    playlist = Playlists.get_playlist!(id)

    case Playlists.delete_playlist(playlist) do
      {:ok, playlist} ->
        {:noreply, push_event(socket, "remove-item", %{id: "playlist-item-#{playlist.id}"})}

      _ ->
        # not sire what to reply here
        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("paginate", %{}, socket) do
    if socket.assigns.page == socket.assigns.track_meta.total_pages do
      {:noreply, socket}
    else
      page = socket.assigns.page + 1

      playlists = list_playlists(page, socket.assigns)
      playlists_meta = track_meta(playlists)

      {:noreply,
       socket
       |> assign(:page, page)
       |> assign(:track_meta, playlists_meta)
       |> assign(:playlists, playlists.entries)}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id="infinite-scroll"
      phx-hook="InfiniteScroll"
      phx-update="append"
      data-page={@page}
      phx-target={@myself}
      data-total-pages={assigns.track_meta.total_pages}
      data-paginate-end={assigns.track_meta.total_pages == @page}
      >
      <%= for playlist <- assigns.playlists  do %>
        <.live_component
          module={RauversionExtension.UI.PlaylistLive.PlaylistComponent}
          id={"playlist-#{playlist.id}"}
          playlist={playlist}
          current_user={@current_user}
          list_ref={@myself}
        />
      <% end %>
    </div>
    """
  end
end
