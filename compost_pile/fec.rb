# biden_for_president = ExternalData.fec_committee.find_by(dataset_id: 'C00703975')
# priorities_usa = ExternalData.fec_committee.find_by(dataset_id:'C00495861')
# america_first_action = ExternalData.fec_committee.find_by(dataset_id: 'C00637512')

OsMatch.includes(:os_donation).order('rand()').limit(1000).each do |os_match|
  er = ExternalData
         .fec_contribution
         .find_by(dataset_id: os_match.os_donation.fectransid)
         &.external_relationship

  if er.nil?
    ColorPrinter.magenta 'missing'
  elsif er.entity1_matched?
    ColorPrinter.print_gray 'matched'
  else
    er.match_entity1_with os_match.donor
    ColorPrinter.print_green 'matching'
  end
end

# how to reset fec tables
# ExternalData.fec_donor.delete_all
# ExternalData.fec_contribution.delete_all
# ExternalData.fec_committee.delete_all
# ExternalRelationship.fec_contribution.delete_all
# ExternalEntity.fec_committee.delete_all
# ExternalEntity.fec_donor.delete_all

# Download data from fec and create data/fec.db
#   $ ./lib/scripts/fec --log=fec_2021_01_03.log --years=2016,2020 --run

# Import into LittleSis
#  $ ./lib/scripts/fec_import.rb
