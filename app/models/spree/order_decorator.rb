Spree::Order.class_eval do
  require 'date'
  require 'spree/order/checkout'

  def valid_delivery_instructions?
    if self.delivery_instructions.length > 500
      self.errors[:delivery_instructions] << 'cannot be longer than 500 charachters'
      return false
    end
    true
  end

  def valid_delivery_date?
    delivery_options = JSON.parse(SpreeDeliveryOptions::Config.delivery_time_options)

    self.errors[:delivery_date] << 'cannot be blank' unless self.delivery_date

    if self.delivery_date
      self.errors[:delivery_date] << 'cannot be today or in the past' if self.delivery_date <= Date.today

      week_day = self.delivery_date.strftime("%A")
      options = delivery_options[week_day.downcase]
      unless options
        self.errors[:delivery_date] << "cannot be on a #{week_day}"
      end

      cutoff_time = Time.now.change(hour: SpreeDeliveryOptions::Config.delivery_cut_off_hour)
      if self.delivery_date == Date.tomorrow && Time.now > cutoff_time
        self.errors[:delivery_date] << "cannot be tomorrow if the order is created after #{SpreeDeliveryOptions::Config.delivery_cut_off_hour}"
      end
    end

    self.errors[:delivery_date].empty? ? true : false
  end

  def valid_delivery_time?
    self.errors[:delivery_time] << 'cannot be blank' unless self.delivery_time

    if self.delivery_time
      delivery_time_options = JSON.parse(SpreeDeliveryOptions::Config.delivery_time_options)
      self.errors[:delivery_time] << 'is invalid' unless delivery_time_options.values.include?(self.delivery_time)
    end

    self.errors[:delivery_time].empty? ? true : false
  end

end

Spree::PermittedAttributes.checkout_attributes << :delivery_date
Spree::PermittedAttributes.checkout_attributes << :delivery_time
Spree::PermittedAttributes.checkout_attributes << :delivery_instructions

Spree::Order.state_machine.before_transition :to => :payment, :do => :valid_delivery_instructions?
Spree::Order.state_machine.before_transition :to => :payment, :do => :valid_delivery_date?
Spree::Order.state_machine.before_transition :to => :payment, :do => :valid_delivery_time?

