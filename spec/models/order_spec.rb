require 'spec_helper'

describe Spree::Order do

  let(:order){Spree::Order.new}

    describe 'delivery instructions' do

      it 'should accept valid delivery instructions' do
        order.delivery_instructions = "This is awesome"
        order.valid_delivery_instructions?.should be_true
        order.errors[:delivery_instructions].should be_empty
      end

      it 'should not accept delivery instructions that are too long' do
        order.delivery_instructions = "A" * 501
        order.valid_delivery_instructions?.should be_false
        order.errors[:delivery_instructions].should_not be_empty
      end

    end

    describe "delivery options" do

      describe "basic validations" do

        it 'should require delivery date' do
          order.valid_delivery_date?.should == false
          order.errors[:delivery_date].should_not be_empty
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

      describe "validating the cut off hour" do

        before :each do
          SpreeDeliveryOptions::Config.delivery_time_options = {monday: ['Between 6-7am']}.to_json
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
          time_now = DateTime.parse("17/11/2013 #{SpreeDeliveryOptions::Config.delivery_cut_off_hour}:01 +1100")
          Timecop.freeze(time_now)

          order.delivery_date = '18/11/2013'
          order.valid_delivery_date?.should == false
          order.errors[:delivery_date].should_not be_empty
          Timecop.return
        end

        it 'should be valid if delivery date is tomorrow but is before the cutoff time' do
          time_now = DateTime.parse("17/11/2013 #{SpreeDeliveryOptions::Config.delivery_cut_off_hour-1}:59 +1100")
          Timecop.freeze(time_now)

          order.delivery_date = '18/11/2013'
          order.valid_delivery_date?
          order.errors[:delivery_date].should be_empty
          Timecop.return
        end

      end

      describe "validating the week day" do

        before :each do
          SpreeDeliveryOptions::Config.delivery_time_options = {monday: ['Between 6-7am']}.to_json
        end

        it 'should allow delivery time to be in a valid delivery day' do
          order.delivery_date =  DateTime.now.next_week.next_day(0)
          order.valid_delivery_date?#.should == true
          order.errors[:delivery_date].should be_empty
        end

        it 'should not allow delivery time to be in a non delivery day' do
          order.delivery_date =  DateTime.now.next_week.next_day(1)
          order.valid_delivery_date?.should == false
          order.errors[:delivery_date].should_not be_empty
        end

      end

      describe "validating delivery time in specific week day" do

        it 'should not allow delivery time to be in an invalid slot for the delivery day'

      end

    end


end
