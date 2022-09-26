defmodule RauversionExtension.UI.ProfileLive.MenuComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  # use Phoenix.LiveComponent
  use RauversionExtension.UI.Web, :live_component

  def render(%{data: _data} = assigns) do
    ~H"""
    <div class="relative dark:bg-black">
    <div class="absolute inset-0 shadow z-30 pointer-events-none" aria-hidden="true"></div>
    <div class="z-20 sticky top-0">
      <div class="max-w-7xl mx-auto flex justify-between items-center px-4 py-5 sm:px-6 sm:py-4 lg:px-8 md:justify-start md:space-x-10">

        <div class="hidden md:flex-1 md:flex md:items-center md:justify-between">
          <nav class="flex space-x-10">
            <%= for %{name: name, url: url, selected: selected, kind: _kind} <- assigns.data do %>
              <% #= selected %>
              <% #= kind %>
              <%= live_redirect name,
                id: "profile-menu-#{name}",
                to: url,
                class: "text-base font-medium #{if selected do "border-b border-b-4 text-gray-800 hover:text-gray-900 border-brand-500 dark:text-gray-200 dark:hover:text-gray-100 dark:border-brand-300 " else "text-gray-500 hover:text-gray-900 dark:text-gray-100 dark:hover:text-gray-100" end}" %>
            <% end %>
          </nav>


          <%= if @current_user && @current_user.id == @profile.id do %>
            <div class="flex items-center md:ml-12">
              <%= live_redirect gettext( "Your insights"), to: routes().profile_index_path(@socket, :insights, @username), class: "text-base font-medium text-gray-500 hover:text-gray-900  dark:text-gray-300 dark:hover:text-gray-100" %>
            </div>
          <% end %>
        </div>
      </div>
    </div>
    </div>
    """
  end
end
