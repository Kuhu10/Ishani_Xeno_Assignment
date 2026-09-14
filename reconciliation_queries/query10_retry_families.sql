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
    COUNT(DISTINCT customer_id) AS target_base
FROM eligible_logs
WHERE root_id IN (
    SELECT id
    FROM campaign
    WHERE parent_id IS NULL
      AND EXISTS (
          SELECT 1
          FROM campaign child
          WHERE child.parent_id = campaign.id
      )
)
GROUP BY root_id
ORDER BY root_id;

/* OUTPUT
root_id | raw_attempts | target_base (Distinct Customers Reached)
--------+--------------+-----------------------------------------
9001    | 13           | 10
9201    | 6            | 5
*/