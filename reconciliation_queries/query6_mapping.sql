SELECT
    c.id AS campaign_id,
    c.parent_id,
    CASE
        WHEN c.parent_id IS NULL THEN 'ROOT'
        ELSE 'RETRY'
    END AS campaign_role
FROM campaign c
ORDER BY c.id;

/* OUTPUT
campaign_id | parent_id | campaign_role
------------+-----------+--------------
9001        | NULL      | ROOT
9002        | 9001      | RETRY
9003        | 9002      | RETRY
9004        | 9001      | RETRY
9101        | NULL      | ROOT
9201        | NULL      | ROOT
9202        | 9201      | RETRY
*/