module Portal::LegalNoticeHelper
  def introduction_text_for(legal_notice)
    case legal_notice.report.case.type
    when 'Cases::Bereavement'
      'We are writing to notify you of the death of the Person mentioned. We have been appointed as Authorised Agent for the purposes of notification and estate due diligence by the duly appointed Legal Representative with authority to administer the estate’s affairs in accordance with the Administration of Estates Act 1925. Please click "Download Statutory Notification of Death" to see more information, as well as a copy of the evidence of death and our Letter of Authority.'
    when 'Cases::MentalCapacity'
      'We are notifying you that the Person mentioned has the enclosed Lasting Power of Attorney (LPA) registered with the Office of the Public Guardian under the Mental Capacity Act 2005 (the Act). We have been appointed as Authorised Agent for the purposes of notification and estate due diligence by the Legal Representative who is responsible for managing property and financial affairs in accordance with the Act. Please click ‘Download Notification’ to see more information, as well as a copy of the LPA and our Letter of Authority.'
    else
      'We are notifying you that the Person mentioned is subject to a Court of Protection Order (CoPO). We have been appointed as Authorised Agent for the purposes of notification and estate due diligence by the Legal Representative who is responsibility for managing property and financial affairs in accordance with the Mental Capacity Act 2005. Please click ‘Download Notification’ to see more information, as well as a copy of the CoPO and our Letter of Authority.'
    end
  end
end