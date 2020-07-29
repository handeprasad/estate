  class Case < ApplicationRecord
    attr_accessor :driving_licence_number_segments, :passport_number_segments, :will_cert_exists, :will_register_search_cert_number_segments

    belongs_to :authorised_user, class_name: 'User', optional: true
    belongs_to :company
    has_many :addresses, dependent: :destroy, as: :owner
    has_many :names, dependent: :destroy
    has_many :previous_employers, dependent: :destroy
    has_many :proofs, -> { where document_id: true }, dependent: :destroy, foreign_key: :case_id
    has_many :orders, validate: false
    has_many :reports, through: :orders
    has_many :documents, as: :document_item, dependent: :destroy
    has_many :audit_logs, as: :auditable, dependent: :destroy
    belongs_to :matter_type
    has_one :next_to_kin, dependent: :destroy, as: :owner, class_name: 'Person'

    accepts_nested_attributes_for :addresses
    accepts_nested_attributes_for :names
    accepts_nested_attributes_for :previous_employers
    #accepts_nested_attributes_for :proofs
    accepts_nested_attributes_for :documents, allow_destroy: true, reject_if: proc { |attributes| attributes[:file].nil? }
    accepts_nested_attributes_for :next_to_kin, reject_if: proc { |attributes| attributes[:firstname].blank? }

    mount_uploader :letter_to_financial_institutions, DocumentUploader

    validates :customer_reference, presence: true, length: { maximum: 20,
     too_long: "%{count} characters is the maximum allowed" }

    validates :authorised_user_id, presence: true
    validates :legal_capacity, presence: true

    validates_date :date_of_birth, allow_blank: true
    validate :over_eighteen, if: -> { date_of_birth.present? && date_of_applicability.present? }
    validate :check_for_date_of_applicability, if: -> { date_of_applicability.present? }
    
    delegate *(Address::PARAMS - [:id]), to: :last_known_address
    delegate *(Name::PARAMS - [:id]), to: :name

    after_touch { reports.each(&:touch) }

    def driving_licence_number_segments
      @driving_licence_number_segments || []
    end

    def passport_number_segments
      @driving_licence_number_segments || []
    end

    def will_register_search_cert_number_segments
      @will_register_search_cert_number_segments || []
    end

    def excluded_fields
      []
    end

    def executor?
      legal_capacity == 0
    end

    def onbehalf_of_executor?
      legal_capacity == 1
    end

    #def build_proofs
    #  proofs.build
    #end

    def intestate?
      return false if self.matter_type.blank?
      self.matter_type.intestate?
    end

    def bereavement?
      if self.matter_type.blank?
        return true if self.type == "Cases::Bereavement"
      else
        return self.matter_type.matter_type == "Bereavement"
      end
      return false
    end

    def can_order_reports?
      return false if self.matter_type.blank?
      mt = self.matter_type
      index = self.class.legal_capacity_list.index(self.legal_capacity)
      if index.to_i > 1
        return true
      else 
        return false
      end
    end

    def next_to_kin_required?
      return false if self.matter_type.blank?
      return self.bereavement? && self.intestate?
    end

    def mental_capacity?
      if self.matter_type.blank?
        return true if self.type == "Cases::MentalCapacity"
      else
        return self.matter_type.matter_type == "MentalCapacity"
      end
      return false
    end

    def copo?
      matter_type&.short_name&.downcase == 'copo'
    end

    def epa?
      matter_type&.short_name&.downcase == 'epa'
    end

    def lpa?
      matter_type&.short_name&.downcase == 'lpa'
    end

    def interim?
      return false if self.matter_type.blank?
      self.matter_type.interim?
    end

    def scottish?
      return false if self.matter_type.blank?
      self.matter_type.scottish?
    end

    def confirmation_of_data_subject_required?
      return false if self.matter_type.blank?
      if self.matter_type.matter_type == "Bereavement"
        return true
      else
        if (self.matter_type.short_name == "CoPO") && (self.firm_is == "member")
          return true
        elsif (self.matter_type.short_name == "LPA" || self.matter_type.short_name == "EPA" || self.matter_type.short_name == "OPA" || self.name == "Continuing Power of Attorney (CPA) (Scotland)" )
          return true
        end
      end
      return false
    end

    def authority_to_act_required?
      return false if self.matter_type.blank?
      if self.matter_type.matter_type == "Bereavement"
        return true
      else
        if (self.matter_type.short_name == "LPA" || self.matter_type.short_name == "EPA" || self.matter_type.short_name == "OPA" || self.name == "Continuing Power of Attorney (CPA) (Scotland)" || self.name == "Enduring Power of Attorney Order (Northern Ireland) 1987" ) && self.firm_is == "acting"
          return true
        end
      end
      return false
    end

    def ens_ordered?
      return (self.orders.collect{|o| o.products.collect{|p| p.class.name.demodulize}}.flatten.uniq.include?("EnhancedNotificationService") rescue false)
    end

    def appointment_of_es_required?
      return false if self.matter_type.blank?
      if self.ens_ordered?
        if self.matter_type.matter_type == "Bereavement"
          return true
        else
          if (self.matter_type.short_name == "CoPO") && (self.firm_is == "member")
            return true
          elsif (self.matter_type.short_name == "LPA" || self.matter_type.short_name == "EPA" || self.matter_type.short_name == "OPA" )
            return true
          end
        end
      end
      return false
    end

    def required_evidences
      options = []
      options.push(1) if self.confirmation_of_data_subject_required?
      options.push(2) if self.authority_to_act_required?
      options.push(3) if self.appointment_of_es_required?
      return options
    end

    def build_documents
      documents.build
    end

    def deletable?
      reports.none?
    end

    def document_categories
      if self.matter_type.blank?
        #this should be removed
        if self.type == "Cases::Bereavement"
          return DocumentCategory.where(document_type: "Bereavement").order(:sequence)
        elsif self.type == "Cases::MentalCapacity"
          return DocumentCategory.where(document_type: "MentalCapacity").order(:sequence)
        else
          return []
        end
      else
        return DocumentCategory.where.not(sequence: nil).where("document_type = ? or document_type is null", self.matter_type.matter_type).order(:sequence)
      end
    end

    def evidences
      (self.documents.order("updated_at desc") + self.proofs.order("updated_at desc")).sort_by(&:updated_at).reverse
    end

    def save_evidences(documents, uploader_id)
      return true if documents.blank?
      #do not use this for evidences update
      documents.each do |document_param|
        unless document_param[:file].blank?
          document = self.documents.find_by(document_category_id: document_param[:document_category_id], uploader_id: uploader_id)
          document = self.documents.new if document.blank?
          document.uploader_id = uploader_id
          document.uploader_type = "User"
          document.document_category_id = document_param[:document_category_id]
          document.file = document_param[:file]
          document.save
        end
      end

    end

    def letter_to_financial_institutions_file_name
      name = self.letter_to_financial_institutions.url.to_s.split("?").first
      name.to_s.split("/").last
    end

    # FIXME: granular validation to show what's missing
    # this isn't using AR validations right now to allow draft cases easily
    def details_complete?
      name.valid? &&
        date_of_birth.present? &&
        date_of_applicability.present? &&
        addresses.any?(&:valid?)
    end

    def last_known_address
      addresses.first || addresses.build
    end

    def previous_addresses
      addresses - [last_known_address]
    end

    def name
      names.first || names.build
    end

    def person
      next_to_kin || Person.new
    end

    def previous_names
      names - [name]
    end

    def age_at_applicability
      date_of_applicability.year - date_of_birth.year - (date_of_applicability.strftime('%m%d') < date_of_birth.strftime('%m%d') ? 1 : 0)
    end

    def case_individual
      self.names.order("created_at desc").first
    end

    def notice_type
      case type
      when 'Cases::Bereavement'
        "Statutory Notification of Death#{' - Intestate (No Will)' if subtype == 'Intestate' || matter_type.name == "Intestate" }"
      when 'Cases::MentalCapacity'
        'Lack of Mental Capacity Legal Notice'
      else
        'Statutory Notification'
      end
    end

    def court_of_protection_order_document_category
      return DocumentCategory.where(archived: false, document_type: self.matter_type.matter_type, option: 1, matter_type_id: self.matter_type_id).first
    end
    
    def case_type

      if self.matter_type
        return self.matter_type.case_type
      else
        return self.model_name.human.titleize
      end
      
    end

    def default_value_for_form
      return "#{self.authorised_user.name} c/o #{self.authorised_user.company.name}" rescue nil
    end

    private
    def over_eighteen
      if age_at_applicability < 18
        errors.add(:date_of_birth, 'invalid - we cannot provide a report for persons under 18.')
      end
    end

    def check_for_date_of_applicability      
      errors.add(:date_of_applicability, 'Warning - Date of Death cannot be in the Future.') if Date.today < self.date_of_applicability
      errors.add(:date_of_applicability, 'Warning - Date of Death cannot be a date earlier than Date of Birth.') if ( self.date_of_birth.present? && self.date_of_birth > self.date_of_applicability )
    end


end
