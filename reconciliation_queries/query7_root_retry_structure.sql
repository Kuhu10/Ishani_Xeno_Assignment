SELECT
    c.id AS campaign_id,
    c.parent_id,
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM campaign child
            WHERE child.parent_id = c.id
        )
        THEN 'HAS_RETRY_CHILD'
        ELSE 'NO_RETRY_CHILD'
    END AS retry_structure
FROM campaign c
WHERE c.parent_id IS NULL
ORDER BY c.id;

/* OUTPUT
campaign_id | parent_id | retry_structure
------------+-----------+-----------------
9001        | NULL      | HAS_RETRY_CHILD
9101        | NULL      | NO_RETRY_CHILD
9201        | NULL      | HAS_RETRY_CHILD
*/