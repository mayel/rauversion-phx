defmodule RauversionWeb.ArticlesLive.Index do
  use RauversionExtension.UI.Web, :live_view
  on_mount UserAuthLiveMount

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
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
    socket |> assign(:kind, :published)
  end

  defp apply_action(socket, :category, %{"id" => category_slug}) do
    socket |> assign(:kind, :category) |> assign(:category_slug, category_slug)
  end

  defp apply_action(socket, :mine, _) do
    socket |> assign(:kind, :mine)
  end
end
