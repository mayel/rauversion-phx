defmodule RauversionExtension.UI.EventsLive.Show do
  use RauversionExtension.UI.Web, :live_view
  on_mount UserAuthLiveMount

  import RauversionExtension
  alias Rauversion.{Events, Repo}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:open, false)}
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

  defp apply_action(socket, :show, %{"id" => id}) do
    event = Events.get_by_slug!(id) |> repo().preload([:user])
    socket |> assign(:event, event)
  end

  defp apply_action(socket, :payment_success, %{"slug" => id}) do
    event = Events.get_by_slug!(id) |> repo().preload([:user])
    socket |> assign(:event, event) |> assign(:payment_success, true)
  end
end
