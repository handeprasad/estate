module Delphi
  module Constants
    module AccountTypes
      ACCOUNT_TYPES = {
        '00' => {
          name: 'Bank',
          description: 'These accounts are normally defaults but can cover any type of account provided by a bank where the product can no longer be identified.',
          secured_loan: false,
          unsecured_loan: true,
          classification: :unsecured
        },

        '01' => {
          name: 'Hire purchase/Conditional sale',
          description: 'An account where the merchandise remains the property of the lender until all repayments are completed.',
          secured_loan: true,
          unsecured_loan: false,
          classification: :secured
        },

        '02' => {
          name: 'Unsecured loan (personal loans etc)',
          description: 'An account covering the borrowing of a fixed amount which is not secured.',
          secured_loan: false,
          unsecured_loan: true,
          classification: :unsecured
        },

        '03' => {
          name: 'Mortgage',
          description: 'A loan for the purchase of a property that is secured by a mortgage deed until the final payment is made.',
          secured_loan: true,
          unsecured_loan: false,
          classification: :secured
        },

        '04' => {
          name: 'Budget (revolving account)',
          description: 'A provision of an account or an agreement for the purchase of goods up to an agreed credit limit.  A revolving account may involve numerous drawdowns and repayments of a percentage of the balance, whereas the budget accounts credit facility is repaid by constant regular amounts.',
          secured_loan: false,
          unsecured_loan: true,
          classification: :unsecured
        },

        '05' => {
          name: 'Credit card/Store card',
          description: 'The customers are allowed to spend up to an agreed credit limit and repayments are a minimal value or a percentage of the balance outstanding.',
          secured_loan: false,
          unsecured_loan: true,
          classification: :unsecured
        },

        '06' => {
          name: 'Charge card',
          description: 'Spending is allowed up to a credit limit but full repayment is expected against the monthly statement.',
          secured_loan: false,
          unsecured_loan: true,
          classification: :unsecured
        },

        '07' => {
          name: 'Rental (TV, brown and white goods)',
          description: 'Where the merchandise always remains the property of the lender/lessor.  The customer makes payments for the use of these goods.',
          secured_loan: true,
          unsecured_loan: false,
          classification: :secured
        },

        '08' => {
          name: 'Mail Order',
          description: 'For all types of mail order portfolios.',
          secured_loan: false,
          unsecured_loan: true,
          classification: :unsecured
        },

        '11' => {
          name: 'Overdraft',
          description: '',
          secured_loan: false,
          unsecured_loan: true,
          classification: :unsecured
        },

        '12' => {
          name: 'CML member - Possession order',
          description: 'Possession order',
          secured_loan: true,
          unsecured_loan: false,
          classification: :secured
        },

        '13' => {
          name: 'CML member - Voluntary surrender',
          description: 'Voluntary surrender.',
          secured_loan: true,
          unsecured_loan: false,
          classification: :secured
        },

        '14' => {
          name: 'CML member - Arrears move',
          description: 'Arrears move.',
          secured_loan: true,
          unsecured_loan: false,
          classification: :secured
        },

        '15' => {
          name: 'Current accounts',
          description: 'For all portfolios operating along the lines of current accounts.  (See Appendix 9).',
          secured_loan: false,
          unsecured_loan: true,
          classification: :unsecured
        },

        '16' => {
          name: 'Second mortgage (secured loan)',
          description: 'A loan secured against an asset or property but the security ranks after the prime mortgage above.',
          secured_loan: true,
          unsecured_loan: false,
          classification: :secured
        },

        '17' => {
          name: 'Credit sale fixed term',
          description: 'Title to the goods passes to the customer on signing the agreement.',
          secured_loan: false,
          unsecured_loan: true,
          classification: :unsecured
        },

        '18' => {
          name: 'Communications',
          description: 'For use by mobile phone, cable or landline communication service providers.',
          secured_loan: false,
          unsecured_loan: true,
          classification: :unsecured
        },

        '19' => {
          name: 'Fixed term deferred payment',
          description: '`Buy now pay later` types of arrangements.  The conditions are similar to HP and credit sale except that the first payment is deferred for an agreed period of time.  (See Appendix 10).',
          secured_loan: true,
          unsecured_loan: false,
          classification: :secured
        },

        '20' => {
          name: 'Variable subscription',
          description: 'Variable rate HP where the monthly payments can vary depending on base rate adjustments.',
          secured_loan: true,
          unsecured_loan: false,
          classification: :secured
        },

        '21' => {
          name: 'Public utility',
          description: 'This category includes gas, water and electricity portfolios but not communications.',
          secured_loan: false,
          unsecured_loan: true,
          classification: :unsecured
        },

        '22' => {
          name: 'Finance lease',
          description: 'Where the rental covers the total amount of the asset plus charges, i.e. the lessor is not at risk.',
          secured_loan: true,
          unsecured_loan: false,
          classification: :secured
        },

        '23' => {
          name: 'Operating lease',
          description: 'The lessee\'s rentals do not cover more than 90% of the costs of the goods and charges i.e. the lessor is taking part of the risk.',
          secured_loan: true,
          unsecured_loan: false,
          classification: :secured
        },

        '24' => {
          name: 'Unpresentable - cheques',
          description: 'To be used by cheque guarantee companies for a bounced cheque.',
          secured_loan: false,
          unsecured_loan: true,
          classification: :unsecured
        },

        '25' => {
          name: 'Flexible Mortgages',
          description: 'An account that is secured by a mortgage deed until the final payment is made, but the account has flexible terms or elements of multiple products, e.g. it contains a current account within the main mortgage account.',
          secured_loan: true,
          unsecured_loan: false,
          classification: :secured
        },

        '26' => {
          name: 'Consolidated Debt',
          description: 'This category should be used where a CAIS member transfers multiple accounts into one collection account for the purposes of debt recovery. This process is referred to as “consolidating debt”.',
          secured_loan: false,
          unsecured_loan: true,
          classification: :unsecured
        },

        '27' => {
          name: 'Combined Credit Account',
          description: 'An account with multiple credit elements.',
          secured_loan: true,
          unsecured_loan: false,
          classification: :secured
        },

        '28' => {
          name: 'Pay Day Loans',
          description: 'Loans secured against salary payments.',
          secured_loan: true,
          unsecured_loan: false,
          classification: :secured
        },

        '29' => {
          name: 'Balloon HP',
          description: 'An account where the merchandise remains the property of the lender until all repayments are completed and there is a balloon repayment element of the product.',
          secured_loan: true,
          unsecured_loan: false,
          classification: :secured
        },

        '30' => {
          name: 'Residential Mortgage',
          description: 'A loan for the purchase of a property that is secured by a mortgage deed until the final payment is made and is to be the primary home of the borrower.',
          secured_loan: true,
          unsecured_loan: false,
          classification: :secured
        },

        '31' => {
          name: 'Buy To Let Mortgage',
          description: 'A loan for the purchase of a property that is secured by a mortgage deed until the final payment is made but is not to be occupied by the borrower and is for buy to let purposes.',
          secured_loan: true,
          unsecured_loan: false,
          classification: :secured
        },

        '32' => {
          name: '100+% LTV Mortgage',
          description: 'A loan for the purchase of a property that is secured by a mortgage deed until the final payment is made and is over 100% loan to valuation ratio.',
          secured_loan: true,
          unsecured_loan: false,
          classification: :secured
        },

        '33' => {
          name: 'Current Account Offset Mortgage',
          description: 'A loan for the purchase of a property that is secured by a mortgage deed until the final payment is made, but where there is an offset of interest with a current account.',
          secured_loan: true,
          unsecured_loan: false,
          classification: :secured
        },

        '34' => {
          name: 'Investment Offset Mortgage',
          description: 'A loan for the purchase of a property that is secured by a mortgage deed until the final payment is made, but where there is an offset of interest with an investment.',
          secured_loan: true,
          unsecured_loan: false,
          classification: :secured
        },

        '35' => {
          name: 'Shared Ownership Mortgage',
          description: 'A loan for the purchase of a property that is secured by a mortgage deed until the final payment is made, but has shared ownership.',
          secured_loan: true,
          unsecured_loan: false,
          classification: :secured
        },

        '36' => {
          name: 'Contingency Liability',
          description: 'Potential liabilities such as guarantees.',
          secured_loan: true,
          unsecured_loan: false,
          classification: :secured
        },

        '37' => {
          name: 'Store Card',
          description: 'Where customers are allowed to spend up to an agreed credit limit and repayments are a minimal value or a percentage of the balance outstanding. Store cards are issued for the use within specific retailer or group.',
          secured_loan: false,
          unsecured_loan: true,
          classification: :unsecured
        },

        '38' => {
          name: 'Multi Function Card',
          description: 'A card account with multiple credit elements.',
          secured_loan: false,
          unsecured_loan: true,
          classification: :unsecured
        },

        '39' => {
          name: 'Water',
          description: 'Utility account for water services.',
          secured_loan: false,
          unsecured_loan: true,
          classification: :unsecured
        },

        '40' => {
          name: 'Gas',
          description: 'Utility account for gas services.',
          secured_loan: false,
          unsecured_loan: true,
          classification: :unsecured
        },

        '41' => {
          name: 'Electricity',
          description: 'Utility account for electricity services.',
          secured_loan: false,
          unsecured_loan: true,
          classification: :unsecured
        },

        '42' => {
          name: 'Oil',
          description: 'Utility account for oil services.',
          secured_loan: false,
          unsecured_loan: true,
          classification: :unsecured
        },

        '43' => {
          name: 'Dual Fuel',
          description: 'An account covering multiple utility services.',
          secured_loan: false,
          unsecured_loan: true,
          classification: :unsecured
        },

        '44' => {
          name: 'Fuel Card (not motor fuel)',
          description: 'An account covering utility services issued with a card.',
          secured_loan: false,
          unsecured_loan: true,
          classification: :unsecured
        },

        '45' => {
          name: 'House Insurance',
          description: 'Credit for house insurance services.',
          secured_loan: false,
          unsecured_loan: false,
          classification: :general_insurance
        },

        '46' => {
          name: 'Car Insurance',
          description: 'Credit for car insurance services.',
          secured_loan: false,
          unsecured_loan: false,
          classification: :general_insurance
        },

        '47' => {
          name: 'Life Insurance',
          description: 'Credit for life insurance services.',
          secured_loan: false,
          unsecured_loan: false,
          classification: :life_insurance
        },

        '48' => {
          name: 'Health Insurance',
          description: 'Credit for health insurance services.',
          secured_loan: false,
          unsecured_loan: false,
          classification: :life_insurance
        },

        '49' => {
          name: 'Card Protection',
          description: 'Credit for payment protection services on cards.',
          secured_loan: false,
          unsecured_loan: true,
          classification: :general_insurance
        },

        '50' => {
          name: 'Mortgage Protection',
          description: 'Credit for payment protection services on mortgages.',
          secured_loan: false,
          unsecured_loan: true,
          classification: :general_insurance
        },

        '51' => {
          name: 'Payment Protection',
          description: 'Credit for general payment protection services.',
          secured_loan: false,
          unsecured_loan: true,
          classification: :general_insurance
        },

        '52' => {
          name: 'Tax',
          description: 'N/A.',
          secured_loan: true,
          unsecured_loan: false,
          classification: :secured
        },

        '53' => {
          name: 'Mobile',
          description: 'An account for mobile phone services.',
          secured_loan: false,
          unsecured_loan: true,
          classification: :unsecured
        },

        '54' => {
          name: 'Fixed Line',
          description: 'An account for fixed line telecommunications.',
          secured_loan: false,
          unsecured_loan: true,
          classification: :unsecured
        },

        '55' => {
          name: 'Cable',
          description: 'An account for cable entertainment services.',
          secured_loan: false,
          unsecured_loan: true,
          classification: :unsecured
        },

        '56' => {
          name: 'Satellite',
          description: 'An account for satellite entertainment services.',
          secured_loan: false,
          unsecured_loan: true,
          classification: :unsecured
        },

        '57' => {
          name: 'Business Line',
          description: 'An account for business telecommunications.',
          secured_loan: false,
          unsecured_loan: true,
          classification: :unsecured
        },

        '58' => {
          name: 'Broadband',
          description: 'An account for broadband services.',
          secured_loan: false,
          unsecured_loan: true,
          classification: :unsecured
        },

        '59' => {
          name: 'Multi Communications',
          description: 'An account for multiple communication services, i.e. mobile, fixed line, cable, satellite, broadband or combination of.',
          secured_loan: false,
          unsecured_loan: true,
          classification: :unsecured
        },

        '60' => {
          name: 'Student Loan',
          description: 'Loans for educational purposes provided under the terms of legislation and controlled by the Department of Education, usually from the Student Loan Company.',
          secured_loan: false,
          unsecured_loan: true,
          classification: :unsecured
        },

        '61' => {
          name: 'Home Credit',
          description: 'The provision of credit, typically for small sum loans, on flexible terms, the repayments for which are collected in instalments by collectors who call at the customer’s home.',
          secured_loan: false,
          unsecured_loan: true,
          classification: :unsecured
        },

        '62' => {
          name: 'Education',
          description: 'A loan for the purposes of education fees.',
          secured_loan: false,
          unsecured_loan: true,
          classification: :unsecured
        },

        '63' => {
          name: 'Property Rental',
          description: 'Rental agreement for a property.',
          secured_loan: false,
          unsecured_loan: true,
          classification: :unsecured
        },

        '64' => {
          name: 'Other Rental',
          description: 'Rental agreement where the customer makes payment for the use of goods.',
          secured_loan: false,
          unsecured_loan: true,
          classification: :unsecured
        },

        '65' => {
          name: 'Fines',
          description: 'N/A Not used',
          secured_loan: false,
          unsecured_loan: true,
          classification: :unsecured
        },

        '66' => {
          name: 'Court Actions',
          description: 'N/A Not used',
          secured_loan: true,
          unsecured_loan: false,
          classification: :secured
        },

        '67' => {
          name: 'Child Maintenance',
          description: 'N/A Not used',
          secured_loan: true,
          unsecured_loan: false,
          classification: :secured
        },

        '68' => {
          name: 'Asset',
          description: 'N/A Not used',
          secured_loan: true,
          unsecured_loan: false,
          classification: :secured
        },

        '69' => {
          name: 'Mortgage and Unsecured Loan',
          description: 'For an account where there is a mixture of a loan, for the purchase of a property that is secured by a mortgage deed until the final payment is made, and an unsecured element. Typically a >100% mortgage type product.',
          secured_loan: true,
          unsecured_loan: false,
          classification: :secured
        },

        '70' => {
          name: 'Gambling',
          description: 'A credit account used for the purpose of gambling, e.g. spread betting.',
          secured_loan: false,
          unsecured_loan: true,
          classification: :unsecured
        }
      }
    end
  end
end
