defmodule RauversionExtension.UI.HomeLive.Index do
  use RauversionExtension.UI.Web, :live_view
  on_mount UserAuthLiveMount

  import RauversionExtension
  alias Rauversion.{Playlists, Tracks, Repo}

  @impl true
  def mount(_params, _session, socket) do
    # @current_user

    {:ok, socket}
  end

  defp list_tracks(page) do
    Tracks.list_public_tracks()
    |> Tracks.with_processed()
    |> Tracks.order_by_likes()
    |> repo().paginate(page: page, page_size: 4)
  end

  defp list_playlists(page) do
    Playlists.list_public_playlists()
    |> Playlists.order_by_likes()
    |> repo().paginate(page: page, page_size: 6)
  end

  defp list_users(_page, _current_user = nil) do
    nil
  end

  defp list_users(page, current_user = %{}) do
    if Code.ensure_loaded?(Rauversion.Accounts), do:
    Rauversion.Accounts.unfollowed_users(current_user)
    |> repo().paginate(page: page, page_size: 5)
  end

  @impl true
  def handle_params(params, _url, socket) do
    case apply_action(socket, socket.assigns.live_action, params) do
      {:ok, reply} ->
        {:noreply, reply}

      {:err, err} ->
        {:noreply, err}

      any ->
        {:noreply, any}
    end
  end

  defp apply_action(socket, :index, _) do
    socket
    |> assign(:page_title, "Listing Tracks")
    |> assign(:tracks, list_tracks(1))
    |> assign(:playlists, list_playlists(1))
    |> assign(:users, list_users(1, socket.assigns.current_user))
  end
end
