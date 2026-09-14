WITH RECURSIVE campaign_root AS (
    SELECT id, id AS root_id
    FROM campaign
    WHERE parent_id IS NULL

    UNION ALL

    SELECT c.id, cr.root_id
    FROM campaign c
    JOIN campaign_root cr
        ON c.parent_id = cr.id
),
eligible_logs AS (
    SELECT cr.root_id, l.customer_id, l.delivery_status 
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
),
per_root AS (
    SELECT root_id, CASE
            WHEN EXISTS (
                SELECT 1
                FROM campaign child
                WHERE child.parent_id = root_id
            )
            THEN COUNT(DISTINCT CASE WHEN delivery_status = 900 THEN customer_id END)
            ELSE COUNT(*)
        END AS qualifying_sends
    FROM eligible_logs
    GROUP BY root_id
)
SELECT COALESCE(SUM(qualifying_sends), 0) AS target_base
FROM per_root;

/* OUTPUT
target_base
-----------
22
*/