defmodule DistributedOrdersWeb.PageController do
  use DistributedOrdersWeb, :controller

  def about(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :about)
  end
end
