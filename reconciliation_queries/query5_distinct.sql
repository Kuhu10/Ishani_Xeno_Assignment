SELECT COUNT(DISTINCT l.customer_id) AS target_base
FROM communication_log l
JOIN campaign c
    ON c.id = l.communication_id
WHERE l.merchant_id = 501
  AND l.communication_type = '2'
  AND l.sent_time >= '2026-10-01'
  AND l.sent_time < '2026-11-01'
  AND c.creation_status IN ('approved','aborted','resumed','stopped')
  AND c.processing_status = 'processed';

/* OUTPUT
target_base
-----------
21
*/