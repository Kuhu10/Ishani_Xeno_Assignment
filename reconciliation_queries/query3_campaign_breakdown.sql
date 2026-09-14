SELECT
    c.id AS campaign_id,
    c.parent_id,
    c.creation_status,
    c.processing_status,
    COUNT(l.id) AS communication_rows
FROM campaign c
JOIN communication_log l
    ON l.communication_id = c.id
WHERE l.merchant_id = 501
  AND l.communication_type = '2'
  AND l.sent_time >= '2026-10-01'
  AND l.sent_time < '2026-11-01'
GROUP BY
    c.id,
    c.parent_id,
    c.creation_status,
    c.processing_status
ORDER BY c.id;

/* OUTPUT 
campaign_id | parent_id | creation_status   | processing_status | communication_rows
------------+-----------+-------------------+-------------------+-------------------
9001        | NULL      | approved          | processed         | 10
9002        | 9001      | approved          | processed         | 2
9003        | 9002      | approved          | processed         | 1
9004        | 9001      | approval_awaiting | processed         | 4
9101        | NULL      | approved          | processed         | 7
9201        | NULL      | approved          | processed         | 5
9202        | 9201      | approved          | processed         | 1
*/