require 'spec_helper'

describe Spree::Order do

  describe "validations" do

    it 'should require delivery date' do
      order = Spree::Order.new
      order.valid?.should == false
      order.errors[:delivery_date].should_not be_empty
    end

    it 'should not be valid if delivery date is in the past' do
      order = Spree::Order.new(delivery_date: Date.yesterday)
      order.valid?.should == false
      order.errors[:delivery_date].should_not be_empty
    end

    it 'should not be valid if delivery date is today' do
      order = Spree::Order.new(delivery_date: Date.today)
      order.valid?.should == false
      order.errors[:delivery_date].should_not be_empty
    end

    it 'should not be valid if delivery date is tomorrow and it is past the cutoff time'
    it 'should be valid if delivery date is tomorrow but is before the cutoff time'
    it 'should be valid if delivery date is after tomorrow'

  end
  
end
