module Delphi
  class FinancialConnection
    include Hashable
    include Dedup
    identifier :full_name, :relationship_to_subject, :last_known_address

    BUREAU_REFS = {
      '1' => 'Same person',
      '2' => 'Same Person Associate (Partner)',
      '3' => 'Unassociated Same Family (Brother/Sister)',
      '4' => 'Potential Alias',
      '5' => 'Address Based Data'
    }

    attr_reader :element
    private :element

    def initialize(element)
      raise TypeError, 'element must of a Nokogiri::XML::Element' unless element.is_a? Nokogiri::XML::Element
      @element = element
    end

    def full_name
      element.at_xpath('AssociateName').children.map(&:content).join(' ')
    end

    def relationship_to_subject
      associate_name = element.at_xpath('AssociateName').children.map(&:content)
      cais_matches   = element.xpath('//CAISDetails').select do |cais_details|
        cais_details.at_xpath('Name').children.map(&:content) == associate_name
      end

      return '(Unknown)' unless cais_matches.any?
      BUREAU_REFS.fetch(cais_matches.first.at_xpath('MatchDetails/BureauRefCategory').content)
    end

    def last_known_address
      element.at_xpath('Location').children.map(&:content).join(", ")
    end

    def date_last_confirmed_at_address
      Date.parse(element.at_xpath('InformationDate').children.reverse.map(&:content).join('/'))
    end
  end
end
