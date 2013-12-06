module Spree
  CheckoutController.class_eval do
    def before_delivery
      packages = @order.shipments.map { |s| s.to_package }
      @differentiator = Spree::Stock::Differentiator.new(@order, packages)
    end
  end
end
