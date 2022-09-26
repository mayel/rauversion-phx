defmodule RauversionWeb.UserSettingsLive.Index do
  use RauversionExtension.UI.Web, :live_view
  on_mount UserAuthLiveMount


  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end




end
