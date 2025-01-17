defmodule RauversionWeb.PlaylistLive.Index do
  use RauversionWeb, :live_view
  on_mount RauversionWeb.UserLiveAuth

  alias Rauversion.Playlists
  alias Rauversion.Playlists.Playlist

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :playlists, list_playlists())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Playlist")
    |> assign(:playlist, Playlists.get_playlist!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Playlist")
    |> assign(:playlist, %Playlist{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Playlists")
    |> assign(:playlist, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    playlist = Playlists.get_playlist!(id)
    {:ok, _} = Playlists.delete_playlist(playlist)

    {:noreply, assign(socket, :playlists, list_playlists())}
  end

  defp list_playlists do
    Playlists.list_playlists()
  end
end
