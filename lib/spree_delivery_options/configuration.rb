module SpreeDeliveryOptions
  class Configuration < Spree::Preferences::Configuration
    preference :delivery_cut_off_hour, :integer, default: 12
    preference :delivery_time_options, :string, default: {early_morning: 'Between 6am-8am'}.to_json
  end
end
