module Delphi
  class AccountSummary
    attr_accessor :accounts

    def initialize(accounts)
      @accounts = accounts
    end

    def opened_within_24_months_prior_to(date)
      accounts.select do |a|
        a.date_opened &&
          a.date_opened >= (date - 24.months) &&
          a.date_opened <= date
      end
    end

    def closed_within_12_months_prior_to(date)
      accounts.select do |a|
        a.date_closed &&
          a.date_closed >= (date - 12.months) &&
          a.date_closed <= date
      end
    end
  end
end
