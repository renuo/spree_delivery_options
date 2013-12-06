require 'spec_helper'

describe Spree::Order do

  let(:order){Spree::Order.new}

  describe "validations" do

    before :each do
      order.stub(:has_step?).and_return false
    end

    context 'without address checkout step' do

      it 'should not require delivery date' do
        order.valid?
        order.errors[:delivery_date].should be_empty
      end

      it 'should not require delivery time' do
        order.valid?
        order.errors[:delivery_time].should be_empty
      end

    end

    context 'with address checkout step' do

      before :each do
        order.stub(:has_step?).with('address').and_return true
      end

      describe 'delivery date' do

        it 'should require delivery date' do
          order.valid?.should == false
          order.errors[:delivery_date].should_not be_empty
        end

        it 'should not be valid if delivery date is in the past' do
          order.delivery_date = Date.yesterday
          order.valid?.should == false
          order.errors[:delivery_date].should_not be_empty
        end

        it 'should not be valid if delivery date is today' do
          order.delivery_date = Date.today
          order.valid?.should == false
          order.errors[:delivery_date].should_not be_empty
        end

        it 'should not be valid if delivery date is tomorrow and it is past the cutoff time' do
          time_now = DateTime.parse("20/11/2013 #{DELIVERY_CUTOFF_HOUR}:01 +1100")
          Timecop.freeze(time_now)

          order.delivery_date = '21/11/2013'
          order.valid?.should == false
          order.errors[:delivery_date].should_not be_empty
          Timecop.return
        end

        it 'should be valid if delivery date is tomorrow but is before the cutoff time' do
          time_now = DateTime.parse("20/11/2013 #{DELIVERY_CUTOFF_HOUR-1}:59 +1100")
          Timecop.freeze(time_now)

          order.delivery_date = '21/11/2013'
          order.valid?
          order.errors[:delivery_date].should be_empty
          Timecop.return
        end

        it 'should be valid if delivery date is after tomorrow' do
          time_now = DateTime.parse("20/11/2013 #{DELIVERY_CUTOFF_HOUR+1}:30 +1100")
          Timecop.freeze(time_now)

          order.delivery_date = '22/11/2013'
          order.valid?
          order.errors[:delivery_date].should be_empty
          Timecop.return
        end

      end

      describe 'delivery time' do

        it 'should accept valid delivery time' do
          order.delivery_time = DELIVERY_TIME_OPTIONS[:early_morning]
          order.valid?
          order.errors[:delivery_time].should be_empty
        end

        it 'should require delivery time' do
          order.valid?.should == false
          order.errors[:delivery_time].should_not be_empty
        end

        it 'should require a valid option for delivery time' do
          order.delivery_time = 'crazy times!'
          order.valid?.should == false
          order.errors[:delivery_time].should_not be_empty
        end

      end

    end

  end
  
end
