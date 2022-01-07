SELECT *
FROM (
  SELECT link.entity2_id AS entity_id,
         JSON_ARRAYAGG(link.relationship_id) AS relationship_ids
         MAX(relationship.amount) AS relationship_amount,
         MAX(relationship.is_current) AS relationship_is_current,
         MAX(relationship.start_date) AS relationship_start_date

  FROM link
  INNER JOIN relationship ON relationship.id = link.relationship_id
  INNER JOIN entity AS connected_entity ON connected_entity.id = link.entity2_id
  WHERE link.entity1_id = @entity.id
        (AND link.category_id = @categroy_id)
  GROUP BY link.entity2_id
) as connected_entities
ORDER BY


entity.link_count DESC
relationship.is_current DESC
relationship.start_date DESC
relationship.amount DESC
