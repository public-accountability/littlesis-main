DIRECTORS = [
  'Mike K. Wirth',
  'Ronald D. Sugar',
  'Wanda M. Austin',
  'John B. Frank',
  'Alice P. Gast',
  'Enrique Hernandez, Jr',
  'Marillyn A. Hewson',
  'Jon M. Huntsman Jr',
  'Charles W. Moorman IV',
  'Dambisa F. Moyo',
  'Debra Reed-Klages',
  'James Umpleby III'
]

FECDonor = Struct.new(:name) do
  def initialize(str)
    super(NameParser.new(str))
  end

  def variations
    variations = []

    if name.middle
      variations << "#{name.last}, #{name.first} #{name.middle}"
        variations << "#{name.last}, #{name.first} #{name.middle_initial}."
        variations << "#{name.last}, #{name.first} #{name.middle_initial}"

        if name.suffix
          variations << "#{name.last} #{name.suffix}, #{name.first} #{name.middle}"
          variations << "#{name.last} #{name.suffix}, #{name.first} #{name.middle_initial}."
          variations << "#{name.last} #{name.suffix}, #{name.first} #{name.middle_initial}"
        end
      else
        variations << "#{name.last}, #{name.first}"

        if name.suffix
          variations << "#{name.last} #{name.suffix}, #{name.first}"
        end
      end

    variations.uniq.map(&:upcase)
  end

  def last_name_count
    ExternalDataset::FECContribution.where("name LIKE ?", "%#{name.last.upcase}%").count
  end

end

donations = DIRECTORS.map { |d| FECDonor.new(d) }.map do |donor|
  puts "Searching for #{donor.name}"

  data = ExternalDataset::FECContribution.where(:name => donor.variations).map do |record|
    record.attributes.merge('committee_name' => record.fec_committee&.cmte_nm,
                            'committee_connected_org_nm' => record.fec_committee&.connected_org_nm,
                            'committee_cand_id' => record.fec_committee&.cand_id)
  end

  {
    name: donor.name.to_s,
    data: data,
    last_name_count: donor.last_name_count,
    variations: donor.variations
  }
end

File.write(Rails.root.join('data/chevron.json'), JSON.pretty_generate(donations))

Utility.save_hash_array_to_csv(Rails.root.join('data/chevron.csv').to_s, donations.map { |d| d[:data] }.flatten)
