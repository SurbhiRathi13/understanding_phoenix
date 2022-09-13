defmodule HelloElixirWeb.HelloElixirController do
  use HelloElixirWeb, :controller

  def index(conn, _params) do #params is the request parameters and, conn is a struct which holds tons of data about the request
    render(conn, :index) #tells phoenix to render index.html
  end

  def show(conn, %{"messenger" => messenger} = params) do
    render(conn, :show, messenger: messenger)
  end
end
