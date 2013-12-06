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

    it 'should not be valid if delivery date is tomorrow and it is past the cutoff time' do
      time_now = DateTime.parse("20/11/2013 #{DELIVERY_CUTOFF_HOUR}:01 +1100")
      Timecop.freeze(time_now)

      order = Spree::Order.new(delivery_date: '21/11/2013')
      order.valid?.should == false
      order.errors[:delivery_date].should_not be_empty
      Timecop.return
    end

    it 'should be valid if delivery date is tomorrow but is before the cutoff time' do
      time_now = DateTime.parse("20/11/2013 #{DELIVERY_CUTOFF_HOUR-1}:59 +1100")
      Timecop.freeze(time_now)

      order = Spree::Order.new(delivery_date: '21/11/2013')
      order.valid?
      order.errors[:delivery_date].should be_empty
      Timecop.return
    end

    it 'should be valid if delivery date is after tomorrow' do
      time_now = DateTime.parse("20/11/2013 #{DELIVERY_CUTOFF_HOUR+1}:30 +1100")
      Timecop.freeze(time_now)

      order = Spree::Order.new(delivery_date: '22/11/2013')
      order.valid?
      order.errors[:delivery_date].should be_empty
      Timecop.return

    end

    it 'should require delivery time' do
      order = Spree::Order.new
      order.valid?.should == false
      order.errors[:delivery_time].should_not be_empty
    end

  end
  
end
