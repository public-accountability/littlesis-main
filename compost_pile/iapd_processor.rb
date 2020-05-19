def run
  ExternalData.iapd_advisors.find_each do |external_data|
    ExternalEntity
      .iapd_advisors
      .find_or_create_by!(external_data: external_data)
      .automatch
  end

  ExternalData.iapd_owners.find_each do |external_data|
    external_entity = ExternalEntity
                        .iapd_owners
                        .find_or_create_by!(external_data: external_data)
                        .automatch

    create_owner_relationships(external_entity: external_entity, external_data: external_data)
  end
end

# Schedule A includes both major owners (i.e. shareholders > 5%) and execute officers.
# This creates one or two ExternalRelationship, depending if the iapd_owner is
# an executive and an owner or just an executive.
def create_owner_relationships(external_entity:, external_data:)
  external_data.wrapped_data.advisor_relationships.each do |hash|
    raise NotImplementedError, 'Cannot handle Schedule B Relationships' if hash['schedule'] == 'B'

    # if unmatched one or both of these will be nil which is okay
    entity1_id = external_entity.entity_id
    entity2_id = ExternalLink.crd.find_by(link_id: hash['advisor_crd_number'].to_s)&.entity_id

    relationship_attributes = {
      'description1' => hash['title_or_status'],
      'position_attributes' =>  {
        'is_board' => hash['title_or_status']&.downcase&.include?('member')
      }
    }
    position = ExternalRelationship
                 .iapd_owners
                 .find_or_create_by!(external_data: external_data,
                                     category_id: Relationship::POSITION_CATEGORY,
                                     entity1_id: entity1_id,
                                     entity2_id: entity2_id)

    position.update!(relationship_attributes: position.relationship_attributes.deep_merge(relationship_attributes))

    ColorPrinter.print_blue "created position relationship #{hash}"

    # Ownership codes (from page 29 of the form adv)
    #   NA    Less than 5%   C     25-50
    #   A     5-10%          D     50-75
    #   B     10-25%         E     75%+
    if %w[A B C D E].include?(hash['ownership_code'])
      ExternalRelationship
        .iapd_owners
        .find_or_create_by!(external_data: external_data,
                            category_id: Relationship::OWNERSHIP_CATEGORY,
                            entity1_id: entity1_id,
                            entity2_id: entity2_id)
      ColorPrinter.print_blue "created ownership relationship: #{hash}"
    end
  end
end
