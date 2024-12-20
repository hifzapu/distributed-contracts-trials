defmodule DistributedOrdersWeb.PaymentLive.New do
  use DistributedOrdersWeb, :live_view
  alias DistributedOrders.ApiClient.Flutterwave

  @available_countries [
    %{
      country: "South Africa",
      currency: "ZAR"
    },
    %{
      country: "Ghana",
      currency: "GHS"
    },
    %{
      country: "Kenya",
      currency: "KES"
    }
  ]

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "New Payment")
      |> assign(:available_countries, @available_countries)
      |> assign(:payment_link, nil)
      |> assign(:payment_form, to_form(%{}, as: "payment"))

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
     <.simple_form for={@payment_form} phx-submit="save_payment">
        <h3 class="text-xl text-zinc-700 py-4">
            Payment Details
        </h3>
        <.input field={@payment_form[:name]} type="text" label="Name" />
        <.input field={@payment_form[:email]} type="email" label="Email" />
        <.input field={@payment_form[:amount]} type="number" label="Amount" />
        <.input field={@payment_form[:currency]} type="select" label="Currency" prompt="Select a Currency" options={Enum.map(@available_countries, & &1.currency)} />
        <:actions>
            <.button phx-disable-with="Saving..." value="add_manufacturer" class="mt-4 btn btn-primary">Get Payment Link</.button>
        </:actions>
    </.simple_form>
    <%= if @payment_link do %>
        <div class="pt-4 grid place-items-center">
            <a href={@payment_link} class="btn btn-primary">Pay Now</a>
        </div>
    <% end %>
    """
  end

  @impl true
  def handle_event("save_payment", %{"payment" => payment_params}, socket) do
    params = %{
      "tx_ref" => "ref" <> UUID.uuid4(),
      "currency" => payment_params["currency"],
      "amount" => payment_params["amount"],
      "customer" => %{
        "email" => payment_params["email"],
        "name" => payment_params["name"]
      },
      "redirect_url" => "/"
    }
    response = Flutterwave.transfer_money(params)

    {:noreply, assign(socket, :payment_link, response.body["data"]["link"])}
  end
end
