module Cases
  class Bereavement < Case
    #NOTE => proofs table is not used any more. please do not use this
    has_many :proofs, class_name: 'Proof::Bereavement', foreign_key: :case_id, inverse_of: :case, dependent: :destroy

    enum legal_capacity: [
      'as the executor',
      'on behalf of the executor',
      'Executor (Named in the Will)',
      'Executor (Named in the Will or Grant of Probate)',
			'Administrator (Named in the Grant of letters of Administration)',
			'Next of Kin'
    ]

    SUBTYPES = ['Standard', 'Intestate']

    ## we prefer a (live) death certificate over a coroner's interim report
    def proof_of_death
      document_category = DocumentCategory.find_by(name: "Certified Copy Death Certificate")
      document = documents.where(document_category: document_category).order("included desc nulls last").first
      unless document.present?
        document_category = DocumentCategory.find_by(name: "Solicitors Death Certificate Verification form")
        document = documents.where(document_category: document_category).order("included desc nulls last").first
      end
      unless document.present?
        document_category = DocumentCategory.find_by(name: "Coroner's Interim certificate")
        document = documents.where(document_category: document_category).order("included desc nulls last").first
      end
      document
    end
    

    def letter_of_authority
      kind = DocumentCategory.find_by(name: "Letter of Authority - Estatesearch")
      document = documents.where(document_category: kind).order("included desc nulls last").first
      if !document.present?
        kind = DocumentCategory.find_by(name: "Grant of Probate")
        document = documents.where(document_category: kind).order("included desc nulls last").first
      end
      document
    end

    def self.legal_capacity_list
      return  [
      'as the executor',
      'on behalf of the executor',
      'Executor (Named in the Will)',
      'Executor (Named in the Will or Grant of Probate)',
      'Administrator (Named in the Grant of letters of Administration)',
      'Next of Kin'
    ]
    end

  end
end
