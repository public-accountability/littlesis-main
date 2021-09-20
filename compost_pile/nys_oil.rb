#!/usr/bin/env -s rails runner

UTILITIES = (<<~NAMES).split("\n").map(&:upcase)
  American Petroleum Institute%
  National Grid%
  Consolidated Edison%
  NRG Energy%
  NRG New York%
  NRG NY%
  Astoria Generating Company%
  Exelon Generation Company%
  National Biodiesel Board
  Covanta Energy%
  Caithness Long island Energy%
  Finch Paper%
  Exxon Mobil%
  National Fuel Gas%
  Empire State Energy%
  ReEnergy Holdings%
  Bayonne Energy Center%
  Electric and Gas Corporation%
  Rochester Gas % Electric Corporation%
  International Paper%
  Empire State Forest Products%
  CPV Valley%
  Cricket Valley Energy Center%
  Empire Generating%
  Arclight Capital Partners%
  New York State Energy Coalition%
  NYS Energy Coalition%
  LS Power%
  Danskammer Energy%
  American Forest % Paper Assoc%
  Independent Petroleum Marketers%
  Innovative Energy Systems%
  Wheelabrator Technologies%
  Couch White%
  Oil Heat Institute of Long Island%
  East Coast Power%
  American Forest % Paper Association%
  Long Island Power Authority%
  Central Hudson Gas % Electric%
  Helix Ravenswood%
  National Grid Voluntary New York%
  National Grid Voluntary NY%
  National Grid USA%NY%
  GRID PAC%NY%
  GRID PAC%NY%
  % GRID PAC%
  IPPNY%
  Consolidated Edison CO%OF NY%
  Consolidated Edison%NY%
  Consolidated Edison%New York%
  Consolidated Edison%INC%
  CON ED%NY%
  % CEIPAC%
  CEIPAC%
NAMES

PACS = [
  ['A01002', 'NATIONAL FUEL GAS NEW YORK POLITICAL ACTION COMMITTEE'],
  ['A12645', 'NATIONAL GRID USA SERVICE COMPANY INC. PAC - NEW YORK ("GRID PAC - NY")'],
  ['A00745', 'NATIONAL GRID VOLUNTARY NEW YORK STATE PAC'],
  ['A66875', 'NRG ENERGY NY PAC'],
  ['A13279', 'NRG NEW YORK PAC'],
  ['A21745', 'NRG NY PAC'],
  ['A00666', 'IPPNY-PAC'],
  ['A01036', 'CONSOLIDATED EDISON COMPANY OF NY, INC. EMPLOYEES'],
  ['A18870', 'CONSOLIDATED EDISON, INC. EMPLOYEES POLITICAL ACTION COMMITTEE (CEIPAC)']
]

IS_CONTRIBUTION = "JSON_VALUE(data, '$.TRANSACTION_CODE') IN ('A', 'B', 'C', 'D')"

FORMATTER = proc do |disclosure|
  disclosure
    .data
    .tap { |h| h['littlesis_dataset_id'] = disclosure.dataset_id }
end

def where_contributions
  UTILITIES
    .map { |u| "JSON_VALUE(data, '$.CORP_30') LIKE '#{u.upcase}'" }
    .join(" OR ")
    .tap { |s| s.replace "( #{s} )" }
end

def utility_disclosures
  ExternalData.nys_disclosure.where(where_contributions)
end

def pacs_disclosures
  ExternalData
    .nys_disclosure
    .where("JSON_VALUE(data, '$.FILER_ID') IN ?", PACS.map(&:first))
end

def save_file(filename)
  Utility.save_hash_array_to_csv(Rails.root.join('data', filename), yield)
end

save_file 'nys_utility_company_all_disclosures.csv' do
  Rails.logger.info utility_disclosures.to_sql
  utility_disclosures.map(&FORMATTER)
end

save_file 'nys_utility_company_contributions_disclosures.csv' do
  Rails.logger.info utility_disclosures.where(IS_CONTRIBUTION).to_sql
  utility_disclosures.where(IS_CONTRIBUTION).map(&FORMATTER)
end

save_file 'nys_utility_pacs_all_contributions.csv' do
  Rails.logger.info pacs_disclosures.to_sql
  pacs_disclosures.map(&FORMATTER)
end

save_file 'nys_utility_pacs_all_contributions.csv' do
  Rails.logger.info pacs_disclosures..where(IS_CONTRIBUTION).to_sql
  pacs_disclosures.where(IS_CONTRIBUTION).map(&FORMATTER)
end
