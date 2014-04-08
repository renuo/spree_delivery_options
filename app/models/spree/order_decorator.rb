Spree::Order.class_eval do
  require 'date'
  require 'spree/order/checkout'

  def valid_delivery_instructions?
    if self.delivery_instructions && self.delivery_instructions.length > 500
      self.errors[:delivery_instructions] << I18n.t('activerecord.errors.models.spree/order.attributes.delivery_instructions.cannot_be_longer_than_500_charachters')
      return false
    end
    true
  end

  def valid_delivery_date?
    self.errors[:delivery_date] << I18n.t('activerecord.errors.messages.blank') unless self.delivery_date
    if self.delivery_date
      self.errors[:delivery_date] << I18n.t('activerecord.errors.models.spree/order.attributes.delivery_date.cannot_be_today_or_in_the_past') if self.delivery_date <= Date.today

      cutoff_time = Time.now.change(hour: SpreeDeliveryOptions::Config.delivery_cut_off_hour)
      if self.delivery_date == Date.tomorrow && Time.now > (cutoff_time + 15.minutes)
        self.errors[:delivery_date] << I18n.t('activerecord.errors.models.spree/order.attributes.delivery_date.cannot_be_tomorrow_if_the_order_is_created_after', cut_off: cutoff_time.hour)
      end
    end

    self.errors[:delivery_date].empty? ? true : false
  end

  def valid_delivery_time?
    return unless self.delivery_date

    self.errors[:delivery_time] << I18n.t('activerecord.errors.messages.blank') unless self.delivery_time

    if self.delivery_time
      self.errors[:delivery_time] << I18n.t('activerecord.errors.messages.invalid') unless (delivery_time_options(self.delivery_date) && delivery_time_options(self.delivery_date).include?(self.delivery_time))
    end

    self.errors[:delivery_time].empty? ? true : false
  end

  private

  def delivery_time_options(date)
    date_string = date.strftime("%d/%m/%Y")
    return delivery_options[date_string] if delivery_options[date_string]

    week_day = date.strftime("%A")
    delivery_options[week_day.downcase]
  end

  def delivery_options
    @delivery_options ||= JSON.parse(SpreeDeliveryOptions::Config.delivery_time_options)
  end

end

Spree::PermittedAttributes.checkout_attributes << :delivery_date
Spree::PermittedAttributes.checkout_attributes << :delivery_instructions

Spree::Order.state_machine.before_transition :to => :payment, :do => :valid_delivery_date?

