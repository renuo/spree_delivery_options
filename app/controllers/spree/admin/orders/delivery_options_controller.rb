module Spree
  module Admin
    module Orders
      class DeliveryOptionsController < Spree::Admin::BaseController

        def edit
          @order = Order.find_by(number: params[:order_id])
        end

        def update
          @order = Order.find_by(number: params[:order_id])
          @order.update_attributes(delivery_options_params)
          render :edit
        end

        private

        def delivery_options_params
          params.require(:order).permit(:delivery_date, :delivery_time, :delivery_instructions)
        end

      end
    end
  end
end
