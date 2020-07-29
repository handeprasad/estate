module Delphi
  class IVAArrangement
    include Constants::PublicInformationDataCodes
    include Hashable

    attr_reader :element
    private :element

    def initialize(element)
      raise TypeError, 'element must be a Nokogiri::XML::Element or similar' unless element.respond_to? :at_xpath
      @element = element
    end

    def amount
      return unless element.at_xpath('AmountPence').present?

      pounds = element.at_xpath('AmountPounds')
      pounds = pounds.nil? ? 0 : pounds.content.gsub(/\D/, '').to_i * 100
      pence  = element.at_xpath('AmountPence').content.to_i

      (pounds + pence).to_f / 100
    end

    def description
      data_code.description
    end

    def classification
      data_code.classification
    end

    def information_date
      return '' if element.at_xpath('InformationDate').nil?
      Date.parse(element.at_xpath('InformationDate').children.reverse.map(&:content).reject(&:blank?).join('/'))
    end

    def name
      return '' if element.at_xpath('Name').nil?
      element.at_xpath('Name').children.map(&:content).reject(&:blank?).join(' ')
    end

    def address
      return '' if element.at_xpath('Location').nil?
      element.at_xpath('Location').children.map(&:content).reject(&:blank?).join(', ')
    end

    def court_plaintiff
      return '' if element.at_xpath('CourtPlaintiff').nil?
      element.at_xpath('CourtPlaintiff').content
    end

    def satisfaction_date
      return '' if element.at_xpath('SatisfactionDate').nil?
      segments = element.at_xpath('SatisfactionDate').children.reverse.map(&:content).reject(&:blank?)
      if segments.last == '0000'
        nil
      else
        Date.parse(segments.join('/'))
      end
    end

    private

    def data_code
      @data_code ||= begin
        if element.at_xpath('InformationType').present?
          DATA_CODES.fetch(element.at_xpath('InformationType').content, UNKNOWN_DATA_CODE)
        else
          UNKNOWN_DATA_CODE
        end
      end
    end
  end
end
