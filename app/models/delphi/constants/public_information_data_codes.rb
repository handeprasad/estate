module Delphi
  module Constants
    module PublicInformationDataCodes
      DataCode = Struct.new(:description, :classification)

      DATA_CODES = {
        '02' => DataCode.new('Judgement',                           'Judgement'),
        '16' => DataCode.new('Set Aside Judgement',                 'Judgement'),
        '17' => DataCode.new('Satisfied Judgement',                 'Judgement'),
        '18' => DataCode.new('Liability Order - Live',              'Liability Order'),
        '19' => DataCode.new('Liability Order - Set Aside',         'Liability Order'),
        '20' => DataCode.new('Liability Order - Settled',           'Liability Order'),
        '26' => DataCode.new('Order of Discharge',                  'Bankruptcy'),
        '29' => DataCode.new('Administration Order',                'Bankruptcy'),
        '33' => DataCode.new('Sequestration',                       'Bankruptcy'),
        '36' => DataCode.new('Set Aside Admin Order',               'Bankruptcy'),
        '38' => DataCode.new('Bankruptcy Order',                    'Bankruptcy'),
        '39' => DataCode.new('Certificate of Unenforceability',     'Civil Procedure'),
        '40' => DataCode.new('Satisfied Administration Order',      'Bankruptcy'),
        '41' => DataCode.new('Bankruptcy Order Annulled',           'Bankruptcy'),
        '42' => DataCode.new('Voluntary Arrangement',               'Bankruptcy'),
        '46' => DataCode.new('Voluntary Arrangement Completed',     'Bankruptcy'),
        '50' => DataCode.new('Irish Adjunction',                    'Bankruptcy'),
        '52' => DataCode.new('Adjudication Annulled',               'Bankruptcy'),
        '53' => DataCode.new('Order of Discharge',                  'Bankruptcy'),
        '54' => DataCode.new('Order of Discharge Suspended',        'Bankruptcy'),
        '55' => DataCode.new('Unknown',                             '?'),
        '56' => DataCode.new('Bill of Sale',                        'Civil Procedure'),
        '57' => DataCode.new('Satisfaction of Bill Of Sale',        'Civil Procedure'),
        '58' => DataCode.new('Discovery Order',                     'Civil Procedure'),
        '59' => DataCode.new('Satisfied Discovery Order',           'Civil Procedure'),
        '60' => DataCode.new('Bankruptcy Restriction Order',        'Bankruptcy'),
        '61' => DataCode.new('Bankruptcy Restriction Undertaking',  'Bankruptcy'),
        '62' => DataCode.new('Income Payment Order',                'Bankruptcy'),
        '63' => DataCode.new('Income Payment Agreement',            'Bankruptcy'),
        '64' => DataCode.new('Fast Track Voluntary Arrangement',    'Bankruptcy'),
        '65' => DataCode.new('Debt Arrangement',                    'Debt Arrangement'),
        '66' => DataCode.new('Debt Arrangement Discharge',          'Debt Arrangement'),
        '67' => DataCode.new('Inhibition',                          'Bankruptcy'),
        '68' => DataCode.new('Inhibition Dismissed',                'Bankruptcy'),
        '70' => DataCode.new('Scottish Trust Deed',                 'IVA'),
        '71' => DataCode.new('Confiscation Order',                  'Public Information'),
        '72' => DataCode.new('Debt Relief Order',                   'Bankruptcy'),
        '73' => DataCode.new('Tax Lien',                            'Public Information'),
        '74' => DataCode.new('High Court Judgment',                 'CCJ'),
        '75' => DataCode.new('High Court Judgment Satisfied ',      'CCJ'),
        '76' => DataCode.new('High Court Judgment Set Aside',       'CCJ'),
        '77' => DataCode.new('Debt Relief Restriction Order',       'Bankruptcy'),
        '78' => DataCode.new('Debt Relief Restriction Undertaking', 'Bankruptcy')
      }

      UNKNOWN_DATA_CODE = DataCode.new('Unknown', 'Unknown')
    end
  end
end
