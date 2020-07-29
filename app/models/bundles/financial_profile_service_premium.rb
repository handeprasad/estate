module Bundles
  class FinancialProfileServicePremium
    def title
      'Financial Profile Premium'
    end

    def description_html_for_case_type(case_type)
=begin
      benefits = ['Credit & Liabilities Search', 'Enhanced Notification Service']
      subject  = 'your client'

      if case_type == 'Cases::Bereavement'
        benefits.concat ['Unidentified Creditor Warranty', 'Additional Costs Warranty']
        subject = 'the Deceased'
      end

      <<-HTML
        <p>A due diligence and compliance pack, including the benefits of Financial Profile Standard (#{benefits.to_sentence})</p>
        <p class="small">Also includes Anti-Money Laundering search of #{subject}, Share Registrar Notification (notifying the leading five share registrars of your client’s situation), Company Directorship search (a useful check on potential assets) and OPG 100 search (a search for registered attorneys or deputies)</p>
      HTML
=end
   <<-HTML
      <p><b>A comprehensive Estatesearch for Assets and Liabilities with enhanced Customer Due Diligence.</b> It contacts all significant financial institutions<font color='red'>*</font> to notify them of the duly appointed legal representative. Requests information on Sole, Joint, Personal and Business, dormant or active account profiles. Includes:</p>
      <ul>
        <li><b>Financial Profile Standard plus</li>
        <li>Anti-Money Laundering (AML) Search</li>
        <li> Companies House Directorship Search (identifies active and resigned Company Directorships)</li>
        <li>Unclaimed Assets Register Experian database searches over 4.5 million records</b></li>
      </ul>
      <p><small><font color='red'>*</font> Financial institutions include: Banks, Building societies, Shareholdings (with Link Asset Services, Computershare, Equiniti), Life policies, Unit & Investments trusts, Pensions (personal schemes only) and National Savings & Investments (NS&I).</small></p>
   HTML
    end

    def products
      [
        :aml,
        :creditors_search,
        :company_directorships,
        :enhanced_notification_service,
        :opg_100_search
      ]
    end

    def price
      18500
    end

    def turnaround_days
      30
    end

    def display_weight
      100
    end

  end

end
