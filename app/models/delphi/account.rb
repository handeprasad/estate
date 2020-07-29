module Delphi
  class Account
    include Hashable

    include Constants::AccountStates
    include Constants::AccountTypes
    include Constants::BalanceCaptions
    include Constants::CompanyTypes
    include Constants::JointAccountFlags
    include Constants::PaymentFrequencies

    include Dedup
    identifier :organisation_name, :number, :date_opened, :state, :balance

    attr_reader :element
    private :element

    def initialize(element)
      raise TypeError, 'element must be a Nokogiri::XML::Element or similar' unless element.respond_to? :at_xpath
      @element = element
    end

    def address
      element.at_xpath('Location').children.reject(&:blank?).map(&:content).join(", ")
    end

    def balance
      balance_history.first
    end

    def balance_history
      element.xpath('AccountBalances').map do |ab|
        0 - ab.at_xpath('AccountBalance').content.to_i.abs
      end
    end

    def balance_caption
      return unless caption = element.at_xpath('Balance/Caption')&.content
      BALANCE_CAPTIONS.fetch(caption)
    end

    def organisation_name
      return '(Unknown)' unless node = element.at_xpath('SupplyCompanyName')
      node.content
    end

    def organisation_type
      CAIS_COMPANY_TYPES.fetch(element.at_xpath('CompanyType').content)
    end

    def type
      ACCOUNT_TYPES.fetch(type_code)[:name]
    end

    def number
      element.at_xpath('AccountNumber').content.gsub(/#/, '*')
    end

    def state
      ACCOUNT_STATES.fetch(element.at_xpath('AccountStatus').content)
    end

    def joint?
      element.at_xpath('JointAccount').present?
    end

    def joint_flag
      return 'No' unless joint?
      JOINT_ACCOUNT_FLAGS.fetch(element.at_xpath('JointAccount').content)
    end

    def open?
      date_closed.nil?
    end

    def date_opened
      field = element.at_xpath('CAISAccStartDate')
      return nil if field.nil?
      Date.parse(field.children.reject(&:blank?).reverse.map(&:content).reject(&:blank?).join('/'))
    end

    def date_closed
      return unless node = element.at_xpath('SettlementDate')
      Date.parse(node.children.reject(&:blank?).reverse.map(&:content).join('/'))
    end

    def credit_limit
      return unless node = element.at_xpath('CreditLimit')
      node.at_xpath('Amount').content.gsub(/\D/, '').to_i
    end

    def date_updated
      Date.parse(element.at_xpath('LastUpdatedDate').children.reject(&:blank?).reverse.map(&:content).join('/'))
    end

    def payment_frequency
      return unless node = element.at_xpath('PaymentFrequency')
      PAYMENT_FREQUENCIES.fetch(node.content)
    end

    def payment_status
      return -1 unless node = element.at_xpath('(AccountBalances)[1]/Status')
      node.content.to_i
    end

    def default_satisfaction_date
      return unless node = element.at_xpath('DefaultSatisfyDate')
      Date.parse(node.children.reverse.map(&:content).join('/'))
    end

    def mortgage?
      type.downcase.include? 'mortgage'
    end

    def classification
      ACCOUNT_TYPES.fetch(type_code)[:classification]
    end

    # TODO: remove, use #classification instead
    def unsecured_loan?
      classification == :unsecured
    end

    # TODO: remove, use #classification instead
    def secured_loan?
      classification == :secured
    end

    def type_code
      element.at_xpath('AccountType')&.content
    end

    private
    def raw_balance_caption
      return unless caption = element.at_xpath('Balance/Caption')
      caption.content
    end
  end
end
