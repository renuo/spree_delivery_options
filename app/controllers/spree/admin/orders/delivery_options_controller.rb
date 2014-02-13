module Spree
  module Admin
    module Orders
      class DeliveryOptionsController < Spree::Admin::BaseController

        def edit
          @order = Order.find_by(number: params[:order_id])
        end

      end
    end
  end
end
