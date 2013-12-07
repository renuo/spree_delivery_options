require 'spec_helper'

describe Spree::Order do

  let(:order){Spree::Order.new}

  describe "validations" do

    describe 'delivery date' do

      it 'should require delivery date' do
        order.valid_delivery_date?.should == false
        order.errors[:delivery_date].should_not be_empty
      end

      it 'should not be valid if delivery date is in the past' do
        order.delivery_date = Date.yesterday
        order.valid_delivery_date?.should == false
        order.errors[:delivery_date].should_not be_empty
      end

      it 'should not be valid if delivery date is today' do
        order.delivery_date = Date.today
        order.valid_delivery_date?.should == false
        order.errors[:delivery_date].should_not be_empty
      end

      it 'should not be valid if delivery date is tomorrow and it is past the cutoff time' do
        time_now = DateTime.parse("20/11/2013 #{YgSpreeDeliveryDate::Config.delivery_cut_off_hour}:01 +1100")
        Timecop.freeze(time_now)

        order.delivery_date = '21/11/2013'
        order.valid_delivery_date?.should == false
        order.errors[:delivery_date].should_not be_empty
        Timecop.return
      end

      it 'should be valid if delivery date is tomorrow but is before the cutoff time' do
        time_now = DateTime.parse("20/11/2013 #{YgSpreeDeliveryDate::Config.delivery_cut_off_hour-1}:59 +1100")
        Timecop.freeze(time_now)

        order.delivery_date = '21/11/2013'
        order.valid_delivery_date?
        order.errors[:delivery_date].should be_empty
        Timecop.return
      end

      it 'should be valid if delivery date is after tomorrow' do
        time_now = DateTime.parse("20/11/2013 #{YgSpreeDeliveryDate::Config.delivery_cut_off_hour+1}:30 +1100")
        Timecop.freeze(time_now)

        order.delivery_date = '22/11/2013'
        order.valid_delivery_date?
        order.errors[:delivery_date].should be_empty
        Timecop.return
      end

    end

    describe 'delivery time' do

      it 'should accept valid delivery time' do
        delivery_time_options = JSON.parse(YgSpreeDeliveryDate::Config.delivery_time_options)
        order.delivery_time = delivery_time_options["early_morning"]
        order.valid_delivery_time?
        order.errors[:delivery_time].should be_empty
      end

      it 'should require delivery time' do
        order.valid_delivery_time?.should == false
        order.errors[:delivery_time].should_not be_empty
      end

      it 'should require a valid option for delivery time' do
        order.delivery_time = 'crazy times!'
        order.valid_delivery_time?.should == false
        order.errors[:delivery_time].should_not be_empty
      end

    end


  end

end
