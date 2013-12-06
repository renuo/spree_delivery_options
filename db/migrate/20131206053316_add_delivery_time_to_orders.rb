class AddDeliveryTimeToOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :delivery_time, :string
  end
end
