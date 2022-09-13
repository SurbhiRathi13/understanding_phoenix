defmodule HelloElixirWeb.Plugs.Locale do
  import Plug.Conn

  @locales ["en", "fr", "de"] #these are the assigned value of locales

  def init(default), do: default #default is "en"

  def call(%Plug.Conn{params: %{"locale" => loc}} = conn, _default) when loc in @locales do
    assign(conn, :locale, loc)
  end

  def call(conn, default) do
    assign(conn, :locale, default)
  end

end
