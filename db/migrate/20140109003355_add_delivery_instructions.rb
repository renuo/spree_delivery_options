class AddDeliveryInstructions < ActiveRecord::Migration
  def change
    add_column :spree_orders, :delivery_instructions, :text
  end
end
