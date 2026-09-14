WITH RECURSIVE campaign_root AS (
    SELECT
        id,
        id AS root_id
    FROM campaign
    WHERE parent_id IS NULL

    UNION ALL

    SELECT
        c.id,
        cr.root_id
    FROM campaign c
    JOIN campaign_root cr
        ON c.parent_id = cr.id
),
eligible_logs AS (
    SELECT
        cr.root_id,
        l.communication_id,
        l.customer_id
    FROM communication_log l
    JOIN campaign c
        ON c.id = l.communication_id
    JOIN campaign_root cr
        ON cr.id = c.id
    WHERE l.merchant_id = 501
      AND l.communication_type = '2'
      AND l.sent_time >= '2026-10-01'
      AND l.sent_time < '2026-11-01'
      AND c.creation_status IN ('approved','aborted','resumed','stopped')
      AND c.processing_status = 'processed'
)
SELECT
    root_id,
    COUNT(*) AS raw_attempts,
    COUNT(DISTINCT customer_id) AS distinct_customers,
    COUNT(DISTINCT communication_id) AS campaigns_in_family
FROM eligible_logs
GROUP BY root_id
ORDER BY root_id;

/* OUTPUT
root_id | raw_attempts | distinct_customers | campaigns_in_family
--------+--------------+--------------------+--------------------
9001    | 13           | 10                 | 3 (9001, 9002, 9003)
9101    | 7            | 6                  | 1 (9101)
9201    | 6            | 5                  | 2 (9201, 9202)
*/