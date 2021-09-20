#!/usr/bin/env -S rails runner

# require 'importers/congress_importer'
# opensecrets_fec_translation = CongressImporter.new.reps.each_with_object({}) do |legislator, h|
#   if legislator.dig('id', 'opensecrets') && legislator.dig('id', 'fec')
#     h.store legislator.dig('id', 'opensecrets'), legislator.dig('id', 'fec')
#   end
# end

opensecrets_fec_translation = JSON.parse(File.read(Rails.root.join('data/opensecrets_fec_map.json')).to_s)

# Member of Congress,District ID,First Elected,cid,firstlastp,oslink
rows = CSV.read(Rails.root.join('data/List_of_Electoral_College_Objectors.csv'), headers: true)

data = rows.delete_if do |row|
  if opensecrets_fec_translation.key?(row['cid'])
    ColorPrinter.print_blue "Found OpenSecrets ID for #{row['Member of Congress']}"
    false
  else
    ColorPrinter.print_red "Missing OpenSecrets ID for #{row['Member of Congress']}"
    true
  end
end.map do |row|

  fec_candidate_ids = opensecrets_fec_translation.fetch(row['cid'])

  committee_ids = ExternalDataset::FECCandidate.where(:cand_id => fec_candidate_ids).pluck(:cand_pcc).uniq

  records = ExternalDataset::FECContribution
              .where(fec_year: 2020)
              .where(:cmte_id => committee_ids)
              .where("transaction_amt >= ?", 1_000)
              .map do |record|

    record.attributes.merge('committee_name' => record.fec_committee&.cmte_nm,
                            'committee_connected_org_nm' => record.fec_committee&.connected_org_nm,
                            'committee_cand_id' => record.fec_committee&.cand_id,
                            'opensecrets_id' => row['cid'])
  end

  ColorPrinter.print_cyan "Found #{records.length} contributions for #{row['Member of Congress']}"

  records
end.flatten

Utility.save_hash_array_to_csv Rails.root.join('data/insurrection_supporters_over_$500_in_2020.csv'), data
