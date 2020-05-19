# frozen_string_literal: true

# The ExternalData "data" column for iapd owners is an array of hashes.
# Each hash represents an owner relationship derived from an SEC filing.
# Each filing has multiple owners and it is common for a single person
# to have both a schedule A (direct relationship) and schedule B (indirect ownership)
# on the same filing.
class ExternalData
  class IapdOwner
    attr_reader :primary_ext

    def initialize(data) # input is the "data" field from ExternalData
      @data = data
      @primary_ext = primary_extension(@data)
    end

    def person?
      @primary_ext == 'Person'
    end

    def org?
      !person?
    end

    # def filing_ids
      # @data.map { |x| x.fetch('filing_id') }.uniq
    # end

    # This selects the most recent filing for each advisor
    # that the owner has a relationship with.
    # Currently it excludes indirect ownerships (schedule B)
    def advisor_relationships
      @data
        .reject { |h| h['schedule'] == 'B' }
        .group_by { |h| h['advisor_crd_number'].to_s }
        .values
        .map! { |arr| arr.max_by { |h| h['filename'] } }
    end

    private

    def primary_extension(data)
      owner_types = data.map { |d| d['owner_type'] }.uniq

      if owner_types.length != 1 && owner_types.include?('I')
        raise Exceptions::LittleSisError,
              "Conflicting owner type in Iapd dataset. Ownerkey = #{owner_key}"
      else
        owner_types.first == 'I' ? 'Person' : 'Org'
      end
    end
  end
end

describe ExternalData::IapdOwner do
  specify 'person owner' do
    owner = ExternalData::IapdOwner.new([
                                          { 'owner_type' => 'I' }
                                        ])
    expect(owner.send(:instance_variable_get, :@primary_ext)).to eq 'Person'
    expect(owner.person?).to be true
  end

  specify 'advisor_relationships' do
    owner = ExternalData::IapdOwner.new attributes_for(:external_data_iapd_owner)[:data]

    expect(owner.advisor_relationships).to eq([
                                                { "filing_id" => 1174430,
                                                  "scha_3" => "Y",
                                                  "schedule" => "A",
                                                  "name" => "BATES, DOUGLAS, K",
                                                  "owner_type" => "I",
                                                  "entity_in_which" => "",
                                                  "title_or_status" => "ADVISORY BOARD",
                                                  "acquired" => "09/2001",
                                                  "ownership_code" => "NA",
                                                  "control_person" => "Y",
                                                  "public_reporting" => "N",
                                                  "owner_id" => "1000018",
                                                  "filename" => "IA_Schedule_A_B_20180101_20180331.csv",
                                                  "owner_key" => "1000018",
                                                  "advisor_crd_number" => 116865
                                                }
                                              ])

  end
