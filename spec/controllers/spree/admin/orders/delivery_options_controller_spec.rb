require 'spec_helper'

describe Spree::Admin::Orders::DeliveryOptionsController do

  let(:user) { mock_model Spree::User, :last_incomplete_spree_order => nil, :has_spree_role? => true, :spree_api_key => 'fake' }

  before :each do
    controller.stub :spree_current_user => user
    controller.stub :check_authorization
  end

  describe 'edit' do

    it 'should render edit' do
      spree_get :edit
      response.should render_template(:edit)
    end

  end

  describe 'update' do

    let(:order){Spree::Order.new}
    let(:tomorrow){Date.tomorrow.strftime("%d/%m/%Y")}

    before :each do
      Spree::Order.stub(:find_by).and_return(order)
      order.stub(:update_attributes).and_return(true)
    end

    it 'should update order' do
      order.should_receive(:update_attributes).with({"delivery_date" => tomorrow})

      spree_post :update, order: {delivery_date: tomorrow}
    end

    it 'should render edit when successful' do
      spree_post :update, order: {delivery_date: tomorrow}
      response.should render_template(:edit)
    end

    it 'should render edit when unsuccessful' do
      order.should_receive(:update_attributes).with({"delivery_date" => tomorrow}).and_return false
      spree_post :update, order: {delivery_date: tomorrow}
      response.should render_template(:edit)
    end

    it 'should not allow to update invalid attributes' do
      order.should_receive(:update_attributes).with({"delivery_date" => tomorrow})
      spree_post :update, order: {delivery_date: tomorrow, crazy: 'blah'}
    end

  end

end
