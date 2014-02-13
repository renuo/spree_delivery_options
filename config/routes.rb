Spree::Core::Engine.routes.draw do

  get "admin/orders/:order_id/delivery_options/", controller: 'admin/orders/delivery_options', action: 'edit', as: 'admin_order_delivery_options'

end
