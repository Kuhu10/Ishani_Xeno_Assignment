SELECT
    c.id AS campaign_id,
    COUNT(l.id) AS communication_rows,
    COUNT(DISTINCT l.customer_id) AS distinct_customers
FROM campaign c
JOIN communication_log l
    ON l.communication_id = c.id
WHERE c.parent_id IS NULL
  AND NOT EXISTS (
      SELECT 1
      FROM campaign child
      WHERE child.parent_id = c.id
  )
  AND l.merchant_id = 501
  AND l.communication_type = '2'
  AND l.sent_time >= '2026-10-01'
  AND l.sent_time < '2026-11-01'
  AND c.creation_status IN ('approved','aborted','resumed','stopped')
  AND c.processing_status = 'processed'
GROUP BY c.id;

/* OUTPUT
campaign_id | communication_rows | distinct_customers
------------+--------------------+-------------------
9101        | 7                  | 6
*/