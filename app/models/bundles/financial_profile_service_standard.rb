module Bundles
  class FinancialProfileServiceStandard
    def title
      'Financial Profile Standard'
    end

    def description_html_for_case_type(case_type)
      html = "<p><b>A comprehensive Estatesearch for Assets and Liabilities.</b> It contacts all significant financial institutions<font color='red'>*</font> to notify them of the duly appointed legal representative. Requests information on Sole, Joint, Personal and Business, dormant or active account profiles. Includes:</p>"
      html << <<-HTML 
        <ul>
          <li><b>Credit and Liabilities Database Search (Statutory Credit Report)</li>
          <li>CIFAS Fraud prevention “Protecting the Vulnerable Service” Registration</li>
          <li>OPG 100 Search (On Mental Capacity Matters where Date of Appointment is older than 6 months)</b></li>
        </ul>
      HTML
=begin
      if case_type == 'Cases::Bereavement'
        html << <<-HTML
          <p>Includes Unidentified Creditor Warranty (protecting Personal Representatives and beneficiaries against subsequent claims up to £50,000 from creditors not identified).</p>
          <p><small>Also includes Additional Costs Warranty, covering up to £5,000 of additional legal and administrative costs incurred, when a Financial Institution, previously notified under the Enhanced Notification Service, subsequently discloses a previously unidentified asset for distribution.</small></p>
        HTML
      end
=end
      html << <<-HTML 
          <p><small><font color='red'>*</font> Financial institutions include: Banks, Building societies, Shareholdings (with Link Asset Services, Computershare, Equiniti), Life policies, Unit & Investments trusts, Pensions (personal schemes only) and National Savings & Investments (NS&I).</small></p>
          HTML
      html
    end

    def products
      [
        :creditors_search,
        :enhanced_notification_service
      ]
    end

    def price
      15500
    end

    def turnaround_days
      30
    end

    def display_weight
      150
    end
  end
end
