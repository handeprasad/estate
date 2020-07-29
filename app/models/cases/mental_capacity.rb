module Cases
  class MentalCapacity < Case
    has_many :proofs, class_name: 'Proof::MentalCapacity', foreign_key: :case_id, inverse_of: :case, dependent: :destroy

    enum legal_capacity: [
      'as the attorney/deputy',
      'on behalf of the attorney/deputy',
      'Court Appointed Deputy (Named in the Court of Protection Order)',
      'Attorney (Named in the Power of Attorney)',
      'Court Appointed Deputy (Named in the Interim Court of Protection Order)',
      'Court Appointed Guardian (Named in the Order)',
      'Court Appointed Controller (Named in the Order)',
      'Court Appointed Guardian (Named in the Interim Order)',
      'Court Appointed Controller (Named in the Interim Order)'
    ]

    SUBTYPES = ['CoPO', 'Enduring PA', 'LPA E&W', 'LPA Scot']

    def self.legal_capacity_list
      [
      'as the attorney/deputy',
      'on behalf of the attorney/deputy',
      'Court Appointed Deputy (Named in the Court of Protection Order)',
      'Attorney (Named in the Power of Attorney)',
      'Court Appointed Deputy (Named in the Interim Court of Protection Order)',
      'Court Appointed Guardian (Named in the Order)',
      'Court Appointed Controller (Named in the Order)',
      'Court Appointed Guardian (Named in the Interim Order)',
      'Court Appointed Controller (Named in the Interim Order)'
    ]
    end

    def excluded_fields
      super + [:protection_policy, :section_27]
    end

    def build_proofs
      Proof::MentalCapacity.kinds.values.each do |kind|
        proofs.build kind: kind
      end
    end

    def court_of_protection_order
      document_category = self.court_of_protection_order_document_category
      document_category = DocumentCategory.find_by(name: "Court of Protection Order") if document_category.blank?
      document = documents.where(document_category: document_category).order("included desc nulls last").first
      document
    end

    def letter_of_authority
      kind = DocumentCategory.find_by(name: "Letter of Authority - Estatesearch")
      document = documents.where(document_category: kind).order("included desc nulls last").first
      document
    end 
  end
end
