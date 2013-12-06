Spree::Order.class_eval do
  require 'date'
  require 'spree/order/checkout'

  DELIVERY_CUTOFF_TIME = '12PM'

  validates :delivery_date, presence: true, allow_nil: false
  validate :delivery_date_rules

  def delivery_date_rules
    return unless self.delivery_date
    self.errors[:delivery_date] << 'cannot be today or in the past' if self.delivery_date <= Date.today
  end

end

Spree::PermittedAttributes.checkout_attributes << :delivery_date
