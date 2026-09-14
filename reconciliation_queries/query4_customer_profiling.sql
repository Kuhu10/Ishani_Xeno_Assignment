SELECT
    l.communication_id AS campaign_id,
    l.customer_id,
    COUNT(*) AS attempts
FROM communication_log l
JOIN campaign c
    ON c.id = l.communication_id
WHERE l.merchant_id = 501
  AND l.communication_type = '2'
  AND l.sent_time >= '2026-10-01'
  AND l.sent_time < '2026-11-01'
  AND c.creation_status IN ('approved','aborted','resumed','stopped')
  AND c.processing_status = 'processed'
GROUP BY
    l.communication_id,
    l.customer_id
ORDER BY
    l.communication_id,
    l.customer_id;

/* OUTPUT
campaign_id | customer_id | attempts
------------+-------------+---------
9001        | C1          | 1
9001        | C2          | 1
9001        | C3          | 1
9001        | C4          | 1
9001        | C5          | 1
9001        | C6          | 1
9001        | C7          | 1
9001        | C8          | 1
9001        | C9          | 1
9001        | C10         | 1
9002        | C2          | 1  
9002        | C3          | 1  
9003        | C3          | 1  
9101        | C20         | 2  
9101        | C21         | 1
9101        | C22         | 1
9101        | C23         | 1
9101        | C24         | 1
9101        | C25         | 1
9201        | D1          | 1
9201        | D2          | 1
9201        | D3          | 1
9201        | D4          | 1
9201        | D5          | 1
9202        | D1          | 1  
*/