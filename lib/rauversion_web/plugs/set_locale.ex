defmodule RauversionExtension.UI.Plugs.SetLocale do
  # 1
  import Plug.Conn
  # 2
  @supported_locales Gettext.known_locales(RauversionExtension.UI.Gettext)

  # 3
  def init(_options), do: nil
  #  4

  def call(%Plug.Conn{params: %{"locale" => locale}} = conn, _options)
      when locale in @supported_locales do
    RauversionExtension.UI.Gettext |> Gettext.put_locale(locale)

    conn
    |> put_session(:locale, locale)
  end

  def call(conn, _options) do
    case fetch_locale_from(conn) do
      nil ->
        conn

      locale ->
        RauversionExtension.UI.Gettext |> Gettext.put_locale(locale)

        conn
        |> put_session(:locale, locale)
    end
  end

  defp fetch_locale_from(conn) do
    (conn.params["locale"] || get_session(conn, :locale))
    |> check_locale
  end

  defp check_locale(locale) when locale in @supported_locales, do: locale
  defp check_locale(_), do: nil
end
