Spree::Order.class_eval do
  require 'date'
  require 'spree/order/checkout'

  DELIVERY_CUTOFF_HOUR = 12
  DELIVERY_TIME_OPTIONS = {
    early_morning: 'Between 6am-8am'
  }

  def valid_delivery_date?
    self.errors[:delivery_date] << 'cannot be blank' unless self.delivery_date

    if self.delivery_date
      self.errors[:delivery_date] << 'cannot be today or in the past' if self.delivery_date <= Date.today

      cutoff_time = Time.now.change(hour: DELIVERY_CUTOFF_HOUR)
      if self.delivery_date == Date.tomorrow && Time.now > cutoff_time
        self.errors[:delivery_date] << "cannot be tomorrow if the order is created after #{DELIVERY_CUTOFF_HOUR}"
      end
    end

    self.errors[:delivery_date].empty? ? true : false
  end

  def valid_delivery_time?
    self.errors[:delivery_time] << 'cannot be blank' unless self.delivery_time

    if self.delivery_time
      self.errors[:delivery_time] << 'is invalid' unless DELIVERY_TIME_OPTIONS.values.include?(self.delivery_time)
    end

    self.errors[:delivery_time].empty? ? true : false
  end

end

Spree::PermittedAttributes.checkout_attributes << :delivery_date
Spree::PermittedAttributes.checkout_attributes << :delivery_time

Spree::Order.state_machine.before_transition :to => :payment, :do => :valid_delivery_date?
Spree::Order.state_machine.before_transition :to => :payment, :do => :valid_delivery_time?

