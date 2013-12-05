Spree::Order.class_eval do
  require 'date'
  require 'spree/order/checkout'

  validate :delivery_date, :presence => true, :allow_nil => false

end

Spree::PermittedAttributes.checkout_attributes << :delivery_date
