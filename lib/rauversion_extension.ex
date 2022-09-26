defmodule RauversionExtension do

  # declare_extension("Rauversion", icon: "twemoji:musical-note")

  def declared_extension, do: %{
      name: "Rauversion",
      module: RauversionExtension,
      href: "/rauversion",
      type: :link,
      icon: "twemoji:musical-note"
    }

  # declare_nav_link([
  #   {("Upload"), href: "/tracks/new", icon: "heroicons-solid:Collection"},
  #   {("Browse Tracks"), href: "/tracks", icon: "emojione:eyes"}
  # ])

  def user_schema, do: Application.get_env(:rauversion_extension, :user_schema, Rauversion.Accounts.User)
  def user_table, do: Application.get_env(:rauversion_extension, :user_table, :users)
  def user_key_type, do: Application.get_env(:rauversion_extension, :user_key_type, :bigserial)
  def user_table_reference, do: Ecto.Migration.references(user_table(),
      type: user_key_type(),
      on_update: :update_all,
      on_delete: :restrict
    )

  def repo, do: Application.get_env(:rauversion_extension, :repo_module, Rauversion.Repo)

  def routes, do: Application.get_env(:rauversion_extension, :router_helper, RauversionWeb.Router.Helpers)

  def default_layout_module, do: Application.get_env(:rauversion_extension, :default_layout_module, RauversionExtension.UI.LayoutView)

end
