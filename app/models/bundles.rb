require_dependency 'bundles/financial_profile_service_standard'
require_dependency 'bundles/financial_profile_service_premium'

module Bundles
  def self.instances
    (self.constants - [:Base]).map { |c| const_get(c).new }.sort_by(&:display_weight)
  end
end
