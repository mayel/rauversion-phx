defmodule RauversionWeb.LikeHelpers do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  def handle_event(
        "like-playlist",
        %{"id" => _id},
        socket = %{
          assigns: %{playlist: playlist, current_user: current_user = %{id: _}}
        }
      ) do
    attrs = %{user_id: current_user.id, playlist_id: playlist.id}

    case socket.assigns.like do
      %Rauversion.PlaylistLikes.PlaylistLike{} = playlist_like ->
        Rauversion.PlaylistLikes.delete_playlist_like(playlist_like)
        {:noreply, assign(socket, :like, nil)}

      _ ->
        {:ok, %Rauversion.PlaylistLikes.PlaylistLike{} = playlist_like} =
          Rauversion.PlaylistLikes.create_playlist_like(attrs)

        {:noreply, assign(socket, :like, playlist_like)}
    end
  end

  def handle_event(
        "like-playlist",
        %{"id" => _id},
        socket = %{assigns: %{playlist: _playlist, current_user: _user = nil}}
      ) do
    # TODO: SHOW MODAL HERE
    {:noreply, socket}
  end

end
