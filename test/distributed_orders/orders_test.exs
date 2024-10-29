defmodule DistributedOrders.OrdersTest do
  use DistributedOrders.DataCase

  alias DistributedOrders.Orders

  describe "orders" do
    alias DistributedOrders.Orders.Order

    import DistributedOrders.OrdersFixtures

    @invalid_attrs %{documents_url: nil, item_name: nil, total_qty: nil}

    test "list_orders/0 returns all orders" do
      order = order_fixture()
      assert Orders.list_orders() == [order]
    end

    test "get_order!/1 returns the order with given id" do
      order = order_fixture()
      assert Orders.get_order!(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      valid_attrs = %{documents_url: "some documents_url", item_name: "some item_name", total_qty: 42}

      assert {:ok, %Order{} = order} = Orders.create_order(valid_attrs)
      assert order.documents_url == "some documents_url"
      assert order.item_name == "some item_name"
      assert order.total_qty == 42
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orders.create_order(@invalid_attrs)
    end

    test "update_order/2 with valid data updates the order" do
      order = order_fixture()
      update_attrs = %{documents_url: "some updated documents_url", item_name: "some updated item_name", total_qty: 43}

      assert {:ok, %Order{} = order} = Orders.update_order(order, update_attrs)
      assert order.documents_url == "some updated documents_url"
      assert order.item_name == "some updated item_name"
      assert order.total_qty == 43
    end

    test "update_order/2 with invalid data returns error changeset" do
      order = order_fixture()
      assert {:error, %Ecto.Changeset{}} = Orders.update_order(order, @invalid_attrs)
      assert order == Orders.get_order!(order.id)
    end

    test "delete_order/1 deletes the order" do
      order = order_fixture()
      assert {:ok, %Order{}} = Orders.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> Orders.get_order!(order.id) end
    end

    test "change_order/1 returns a order changeset" do
      order = order_fixture()
      assert %Ecto.Changeset{} = Orders.change_order(order)
    end
  end
end
