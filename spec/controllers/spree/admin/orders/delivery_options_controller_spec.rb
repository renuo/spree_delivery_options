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

end
